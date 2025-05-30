#!/bin/bash

echo "Iniciando la configuración de dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

echo "Directorio de dotfiles: $DOTFILES_DIR"
echo "Directorio HOME: $USER_HOME"

echo "Configurando archivos en $USER_HOME..."
ln -sf "$DOTFILES_DIR/.zshrc" "$USER_HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$USER_HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.gitconfig" "$USER_HOME/.gitconfig"
# ln -sf "$DOTFILES_DIR/.gitignore_global" "$USER_HOME/.gitignore_global"

echo "Configurando $USER_HOME/.config/ directorios..."
mkdir -p "$USER_HOME/.config"

echo "Configurando Neovim..."
ln -sf "$DOTFILES_DIR/.config/nvim" "$USER_HOME/.config/nvim"

echo "Configurando Kitty..."
ln -sf "$DOTFILES_DIR/.config/kitty" "$USER_HOME/.config/kitty"

echo "Configurando Visual Studio Code..."
mkdir -p "$USER_HOME/.config/Code/User/"
ln -sf "$DOTFILES_DIR/.config/Code/User/settings.json" "$USER_HOME/.config/Code/User/settings.json"
ln -sf "$DOTFILES_DIR/.config/Code/User/keybindings.json" "$USER_HOME/.config/Code/User/keybindings.json"
# mkdir -p "$USER_HOME/.config/Code/User/snippets/"
# ln -sf "$DOTFILES_DIR/.config/Code/User/snippets" "$USER_HOME/.config/Code/User/snippets"

echo "Configurando tema personalizado de Visual Studio Code..."
mkdir -p "$USER_HOME/.vscode/extensions/"
ln -sf "$DOTFILES_DIR/.vscode/extensions/kittynordic-theme" "$USER_HOME/.vscode/extensions/kittynordic-theme"

# echo "Configurando Docker..."
# mkdir -p "$USER_HOME/.docker"
# ln -sf "$DOTFILES_DIR/.docker/config.json" "$USER_HOME/.docker/config.json"

echo "Configurando Podman..."
ln -sf "$DOTFILES_DIR/.config/containers" "$USER_HOME/.config/containers"

if [ -d "$DOTFILES_DIR/bin" ] && [ "$(ls -A $DOTFILES_DIR/bin)" ]; then
    echo "Copiando scripts a /usr/local/bin/ (puede requerir sudo)..."
    chmod +x "$DOTFILES_DIR/bin/"*
    
    read -p "¿Deseas copiar los scripts a /usr/local/bin usando sudo? (s/N): " response
    if [[ "$response" =~ ^([sS][iI]?|[yY])$ ]]; then
        sudo cp -i "$DOTFILES_DIR/bin/"* "/usr/local/bin/"
        echo "Scripts copiados."
    else
        echo "Omitting script copy to /usr/local/bin."
    fi
else
    echo "No se encontraron scripts en $DOTFILES_DIR/bin/ para copiar."
fi

echo "Configuración de dotfiles completada."
echo "Reinicia tu terminal o ejecuta 'source ~/.zshrc'."
echo "Para IntelliJ IDEA, importa tus settings desde el .zip manualmente."
