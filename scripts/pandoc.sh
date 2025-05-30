#!/bin/bash

# Verificar que se pase el argumento correcto
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <ruta-completa-al-archivo.md>"
    echo "Ejemplo: $0 /home/usuario/documentos/mi_informe.md"
    exit 1
fi

# Asignar argumento a variable
ruta_completa_entrada="$1"

# Verificar si el archivo de entrada existe
if [ ! -f "$ruta_completa_entrada" ]; then
    echo "Error: El archivo de entrada '$ruta_completa_entrada' no existe."
    exit 1
fi

# Verificar si el archivo tiene la extensión .md
if [[ "$ruta_completa_entrada" != *.md ]]; then
    echo "Error: El archivo de entrada debe tener la extensión .md."
    echo "Proporcionado: $ruta_completa_entrada"
    exit 1
fi

# Extraer el directorio del archivo de entrada
directorio_entrada=$(dirname "$ruta_completa_entrada")
# Si el archivo está en el directorio actual, dirname devuelve "."
# Docker maneja bien "." como ruta de volumen
if [ "$directorio_entrada" == "." ]; then
    directorio_entrada_abs=$(pwd) # Usar path absoluto para mayor claridad si es "."
else
    directorio_entrada_abs="$directorio_entrada"
fi


# Extraer el nombre del archivo de entrada (con extensión)
nombre_archivo_entrada_con_ext=$(basename "$ruta_completa_entrada")

# Extraer el nombre base del archivo (sin extensión .md)
# Esto se hace para que "archivo.md" se convierta en "archivo"
nombre_base_entrada="${nombre_archivo_entrada_con_ext%.md}"

# Definir el nombre del archivo de salida (con extensión .docx)
# Este nombre será usado DENTRO del contenedor, relativo a /data
archivo_salida_en_contenedor="$nombre_base_entrada.docx"

echo "Procesando archivo: $ruta_completa_entrada"
echo "Directorio a montar: $directorio_entrada_abs"
echo "Archivo de entrada (en contenedor): $nombre_archivo_entrada_con_ext"
echo "Archivo de salida (en contenedor): $archivo_salida_en_contenedor"

# Ejecutar el comando de conversión con Pandoc
# Montamos el directorio del archivo de entrada en /data
# Pandoc opera con los nombres de archivo relativos a /data dentro del contenedor
docker run --rm \
    --volume "$directorio_entrada_abs:/data" \
    --user "$(id -u):$(id -g)" \
    pandoc/core "$nombre_archivo_entrada_con_ext" -o "$archivo_salida_en_contenedor"

# Construir la ruta completa del archivo de salida para el mensaje final
ruta_completa_salida="$directorio_entrada_abs/$archivo_salida_en_contenedor"

if [ -f "$ruta_completa_salida" ]; then
    echo "Conversión completada: $ruta_completa_salida"
else
    echo "Error: La conversión falló o el archivo de salida no se creó en la ubicación esperada: $ruta_completa_salida"
    exit 1
fi
