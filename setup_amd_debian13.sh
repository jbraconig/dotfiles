#!/bin/bash
# Script de configuración completo para Debian 13 (AMD + Dotfiles Dependencies)
# Requiere sudo para instalar paquetes

echo "🔄 Actualizando lista de paquetes..."
sudo apt update && sudo apt upgrade -y

echo "🛠️  Instalando dependencias base del sistema..."
sudo apt install -y zsh fzf unzip git curl wget build-essential

echo "📦 Instalando herramientas modernas (Rust alternatives)..."
# Debian 13 (Trixie) debería tener paquetes recientes.
# Si bat o lsd no están, se podrían instalar via cargo, pero probamos apt primero.
sudo apt install -y bat lsd

# Hack para que batcat sea accesible como bat
if command -v batcat &> /dev/null; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    echo "🔗 Enlace 'bat' -> 'batcat' creado en ~/.local/bin"
fi

echo "🅰️  Instalando fuentes (Hack Nerd Font)..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/HackNerdFont-Regular.ttf" ]; then
    echo "Descargando Hack Nerd Font..."
    wget -qO /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
    unzip -o -q /tmp/Hack.zip -d "$FONT_DIR"
    rm /tmp/Hack.zip
    echo "Actualizando caché de fuentes..."
    fc-cache -fv
    echo "✅ Fuente Hack Nerd Font instalada."
else
    echo "✅ Hack Nerd Font ya está instalada."
fi

echo "📦 Instalando firmware y microcódigo AMD..."
sudo apt install -y firmware-amd-graphics firmware-linux firmware-linux-nonfree amd64-microcode

echo "🎮 Instalando librerías para aceleración 3D y Vulkan..."
sudo apt install -y mesa-vulkan-drivers libgl1-mesa-dri

echo "📊 Instalando utilidades de monitoreo y video..."
sudo apt install -y vainfo vdpauinfo radeontop lm-sensors mesa-utils vulkan-tools

echo "🎵 Instalando códecs y soporte multimedia..."
sudo apt install -y ffmpeg libavcodec-extra gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly gstreamer1.0-libav

echo "🖥️ Verificando driver AMD..."
lspci -k | grep -EA3 'VGA|3D'

echo "⚙️ Detectando sensores..."
sudo sensors-detect --auto

echo "🔍 Comprobando aceleración 3D..."
glxinfo | grep "direct rendering" && echo "✅ Aceleración 3D habilitada" || echo "⚠️ No se encontró soporte 3D"

echo "🔍 Comprobando soporte Vulkan..."
vulkaninfo | grep "apiVersion" && echo "✅ Soporte Vulkan habilitado" || echo "⚠️ No se encontró soporte Vulkan"

echo "✅ Configuración de sistema y dependencias finalizada."
echo "ℹ️  Recuerda reiniciar para cargar drivers y fuentes correctamente."
