#!/bin/bash

# Verificar que se pasen los argumentos correctos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <ruta-completa-al-archivo-entrada> <ruta-completa-al-archivo-salida>"
    echo "Ejemplo: $0 /home/usuario/documentos/mi_informe.md /home/usuario/documentos/mi_informe.docx"
    echo "Ejemplo: $0 /home/usuario/documentos/mi_informe.html /home/usuario/documentos/mi_informe.pdf"
    exit 1
fi

ruta_completa_entrada="$1"
ruta_completa_salida="$2"

# Verificar si el archivo de entrada existe
if [ ! -f "$ruta_completa_entrada" ]; then
    echo "Error: El archivo de entrada '$ruta_completa_entrada' no existe."
    exit 1
fi

# Verificar o crear el directorio de salida
directorio_salida=$(dirname "$ruta_completa_salida")
if [ ! -d "$directorio_salida" ]; then
    mkdir -p "$directorio_salida"
fi

# Detectar contenedor disponible
if command -v podman >/dev/null 2>&1; then
    runtime="podman"
else
    runtime="docker"
fi

# Seleccionar imagen según extensión de salida
extension_salida="${ruta_completa_salida##*.}"
case "$extension_salida" in
    pdf)
        image="docker.io/pandoc/latex"
        ;;
    *)
        image="docker.io/pandoc/core"
        ;;
esac

# Determinar paths absolutos
directorio_entrada=$(dirname "$ruta_completa_entrada")
directorio_entrada_abs=$(realpath "$directorio_entrada")
directorio_salida_abs=$(realpath "$directorio_salida")

nombre_archivo_entrada_con_ext=$(basename "$ruta_completa_entrada")
nombre_archivo_salida_con_ext=$(basename "$ruta_completa_salida")

echo "Procesando archivo: $ruta_completa_entrada"
echo "Usando contenedor: $image"
echo "Directorio de entrada a montar: $directorio_entrada_abs"
echo "Directorio de salida a montar: $directorio_salida_abs"

# Ejecutar la conversión
$runtime run --rm \
    -v "$directorio_entrada_abs:/data" \
    -v "$directorio_salida_abs:/output" \
    --user "$(id -u):$(id -g)" \
    "$image" "/data/$nombre_archivo_entrada_con_ext" -o "/output/$nombre_archivo_salida_con_ext"

# Verificar resultado
if [ -f "$ruta_completa_salida" ]; then
    echo "✅ Conversión completada: $ruta_completa_salida"
else
    echo "❌ Error: La conversión falló o el archivo de salida no se creó: $ruta_completa_salida"
    exit 1
fi
