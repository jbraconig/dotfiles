#!/bin/bash
# Script de configuración para AMD en Debian 13
# Requiere sudo para instalar paquetes

echo "🔄 Actualizando lista de paquetes..."
sudo apt update && sudo apt upgrade -y

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

echo "♻️ Reinicia el sistema para aplicar todos los cambios."
echo "✅ Configuración AMD en Debian 13 finalizada."
