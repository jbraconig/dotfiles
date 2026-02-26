#!/usr/bin/env bash
# Romper el script si hay algún error o variable no definida
set -euo pipefail

echo "🚀 Iniciando proceso de compilación de Ghostty con Podman..."

# --- Variables de entorno ---
IMAGE_NAME="ghostty-builder-trixie"
CONTAINER_NAME="ghostty-extractor-tmp"
INSTALL_DIR_BIN="$HOME/.local/bin"
INSTALL_DIR_SHARE="$HOME/.local/share"

# Directorio temporal para no ensuciar tu workspace
TEMP_DIR=$(mktemp -d)
# GARANTÍA: Asegurar la limpieza del directorio temporal incluso si el script falla en el medio
trap 'rm -rf "$TEMP_DIR"' EXIT

# 1. Crear el Containerfile al vuelo
echo "📝 Generando Containerfile para Debian Trixie..."
cat << 'EOF' > "$TEMP_DIR/Containerfile"
FROM debian:trixie-slim

# Evitar prompts interactivos de apt
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias base de Debian
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates curl xz-utils build-essential pkg-config \
    libgtk-4-dev libadwaita-1-dev libgtk4-layer-shell-dev gettext \
    libxml2-utils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Descargar e instalar Zig
RUN curl -L https://ziglang.org/download/0.15.2/zig-x86_64-linux-0.15.2.tar.xz | tar -xJ && \
    mv zig-x86_64-* /usr/local/zig
ENV PATH="/usr/local/zig:$PATH"

# --- CACHE BURSTER ---
# Este argumento cambia en cada ejecución, obligando a Podman a ignorar
# el caché desde este punto hacia abajo para asegurar que traigas código nuevo.
ARG CACHE_BUST=1

# Descargar y extraer el tarball de la versión tip
RUN curl -L https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz | tar -xz --strip-components=1 -C .

# Compilar indicando un prefijo limpio (/app/out) para facilitar la extracción
RUN zig build -p /app/out -Doptimize=ReleaseFast
EOF

# 2. Construir la imagen con Podman
# Inyectamos el timestamp actual como CACHE_BUST
echo "📦 Construyendo/Actualizando la imagen..."
podman build --build-arg CACHE_BUST="$(date +%s)" -t "$IMAGE_NAME" "$TEMP_DIR"

# 3. Extracción de binarios y dependencias
echo "🛠️ Extrayendo artefactos al sistema host..."
mkdir -p "$INSTALL_DIR_BIN" "$INSTALL_DIR_SHARE"

# Nos aseguramos de borrar el contenedor temporal si falló una ejecución previa
podman rm -f "$CONTAINER_NAME" 2>/dev/null || true

# Crear contenedor sin iniciarlo
podman create --name "$CONTAINER_NAME" "$IMAGE_NAME"

# Copiar el binario principal
podman cp "$CONTAINER_NAME":/app/out/bin/ghostty "$INSTALL_DIR_BIN/"

# Copiar recursos críticos (shell integration, themes)
podman cp "$CONTAINER_NAME":/app/out/share/ghostty "$INSTALL_DIR_SHARE/"

# Copiar terminfo (Vital para que funcionen los colores/teclas en SSH o tmux)
podman cp "$CONTAINER_NAME":/app/out/share/terminfo "$INSTALL_DIR_SHARE/"

# Copiar integraciones de escritorio (iconos y archivo .desktop)
podman cp "$CONTAINER_NAME":/app/out/share/applications "$INSTALL_DIR_SHARE/" || true
podman cp "$CONTAINER_NAME":/app/out/share/icons "$INSTALL_DIR_SHARE/" || true

# Corregir rutas hardcodeadas en los archivos .desktop generados por zig
find "$INSTALL_DIR_SHARE/applications" -name "*.desktop" -exec sed -i -e "s|/app/out/bin/ghostty|$INSTALL_DIR_BIN/ghostty|g" -e "s|^DBusActivatable=true|DBusActivatable=false|g" {} + || true

# 4. Limpieza del entorno
echo "🧹 Limpiando contenedor extractor temporal..."
podman rm "$CONTAINER_NAME" > /dev/null

# Actualizar base de datos del entorno de escritorio si están los comandos disponibles
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$INSTALL_DIR_SHARE/applications" || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t "$INSTALL_DIR_SHARE/icons/hicolor" || true
fi

echo "✅ ¡Ghostty se ha compilado e instalado correctamente!"
echo "👉 Asegúrate de tener $INSTALL_DIR_BIN en la variable \$PATH de tu entorno."

# 5. Comprobar dependencias en el host
if command -v ldd >/dev/null 2>&1; then
    MISSING_LIBS=$(ldd "$INSTALL_DIR_BIN/ghostty" 2>/dev/null | grep "not found" || true)
    if [ -n "$MISSING_LIBS" ]; then
        echo -e "\n⚠️  ADVERTENCIA: Faltan dependencias compartidas en tu sistema host para ejecutar Ghostty:"
        echo "$MISSING_LIBS" | awk '{print "   - "$1}'
        echo "   👉 Probablemente necesites instalar los paquetes de ejecución correspondientes."
        echo "   Ejemplo en Debian/Ubuntu: sudo apt install libgtk4-layer-shell0 libadwaita-1-0"
    fi
fi

