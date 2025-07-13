#!/bin/bash

echo "Iniciando la configuración de dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

echo "Directorio de dotfiles: $DOTFILES_DIR"
echo "Directorio HOME: $USER_HOME"

echo "Configurando directorios de .config/..."
mkdir -p "$USER_HOME/.config"

echo "Configurando Neovim..."
ln -sf "$DOTFILES_DIR/.config/nvim" "$USER_HOME/.config/nvim"

echo "Configurando Kitty..."
ln -sf "$DOTFILES_DIR/.config/kitty" "$USER_HOME/.config/kitty"

echo "Configurando tema personalizado de Visual Studio Code..."
mkdir -p "$USER_HOME/.vscode/extensions/"
ln -sf "$DOTFILES_DIR/.vscode/extensions/kittynordic-theme" "$USER_HOME/.vscode/extensions/kittynordic-theme"

if [ -d "$DOTFILES_DIR/scripts" ] && [ "$(ls -A "$DOTFILES_DIR/scripts")" ]; then
    echo "Creando enlaces simbólicos para scripts en /usr/local/bin/ (puede requerir sudo)..."
    chmod +x "$DOTFILES_DIR/scripts/"*
    
    read -p "¿Deseas crear los enlaces simbólicos en /usr/local/bin usando sudo? (s/N): " response
    if [[ "$response" =~ ^([sS][iI]?|[yY])$ ]]; then
        for script in "$DOTFILES_DIR/scripts/"*; do
            script_name=$(basename "$script")
            sudo ln -sf "$script" "/usr/local/bin/$script_name"
        done
        echo "Enlaces simbólicos creados."
    else
        echo "Se omitió la creación de enlaces simbólicos."
    fi
else
    echo "No se encontraron scripts en $DOTFILES_DIR/scripts/ para enlazar."
fi

echo "Configuración de dotfiles completada."
echo "Reinicia tu terminal para que los cambios surtan efecto."
