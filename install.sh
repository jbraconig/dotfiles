#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_HOME="$HOME"

echo "Directorio de dotfiles: $DOTFILES_DIR"
echo "Directorio HOME: $USER_HOME"

configure_configs() {
    echo "Configurando directorios de .config/..."
    mkdir -p "$USER_HOME/.config"

    echo "Configurando Neovim..."
    ln -sf "$DOTFILES_DIR/.config/nvim" "$USER_HOME/.config/nvim"

    echo "Configurando Kitty..."
    ln -sf "$DOTFILES_DIR/.config/kitty" "$USER_HOME/.config/kitty"

    echo "Configurando tema personalizado de Visual Studio Code..."
    mkdir -p "$USER_HOME/.vscode/extensions/"
    ln -sf "$DOTFILES_DIR/.vscode/extensions/kittynordic-theme" "$USER_HOME/.vscode/extensions/kittynordic-theme"

    echo "Configurando Zsh..."
    ln -sf "$DOTFILES_DIR/.zshrc" "$USER_HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh" "$USER_HOME/.zsh"
}

configure_scripts() {
    if [ -d "$DOTFILES_DIR/scripts" ] && [ "$(ls -A "$DOTFILES_DIR/scripts")" ]; then
        echo "Creando enlaces simbólicos para scripts en /usr/local/bin/ (puede requerir sudo)..."
        chmod +x "$DOTFILES_DIR/scripts/"*
        
        read -p "¿Deseas crear los enlaces simbólicos en /usr/local/bin usando sudo? (s/N): " response
        if [[ "$response" =~ ^([sS][iI]?|[yY])$ ]]; then
            for script in "$DOTFILES_DIR/scripts/"*; do
                script_name_with_ext=$(basename "$script")
                script_name_no_ext="${script_name_with_ext%.*}"
                sudo ln -sf "$script" "/usr/local/bin/$script_name_no_ext"
            done
            echo "Enlaces simbólicos creados."
        else
            echo "Se omitió la creación de enlaces simbólicos."
        fi
    else
        echo "No se encontraron scripts en $DOTFILES_DIR/scripts/ para enlazar."
    fi
}

run_all() {
    configure_configs
    configure_scripts
    echo "Configuración de dotfiles completada."
    echo "Reinicia tu terminal para que los cambios surtan efecto."
}

validate_config() {
    echo "Validando configuración..."

    # Check .config directory
    if [ -d "$USER_HOME/.config" ]; then
        echo "✓ Directorio .config existe."
    else
        echo "✗ Directorio .config no existe."
    fi

    # Check Neovim
    if [ -L "$USER_HOME/.config/nvim" ] && [ "$(readlink "$USER_HOME/.config/nvim")" = "$DOTFILES_DIR/.config/nvim" ]; then
        echo "✓ Neovim configurado correctamente."
    else
        echo "✗ Neovim no está configurado o el enlace simbólico es incorrecto."
    fi

    # Check Kitty
    if [ -d "$USER_HOME/.config/kitty" ] && [ -L "$USER_HOME/.config/kitty/kitty.conf" ] && [ "$(readlink "$USER_HOME/.config/kitty/kitty.conf")" = "$DOTFILES_DIR/.config/kitty/kitty.conf" ]; then
        echo "✓ Kitty configurado correctamente."
    else
        echo "✗ Kitty no está configurado correctamente."
    fi

    # Check VS Code theme
    if [ -L "$USER_HOME/.vscode/extensions/kittynordic-theme" ] && [ "$(readlink "$USER_HOME/.vscode/extensions/kittynordic-theme")" = "$DOTFILES_DIR/.vscode/extensions/kittynordic-theme" ]; then
        echo "✓ Tema de VS Code configurado correctamente."
    else
        echo "✗ Tema de VS Code no está configurado o el enlace simbólico es incorrecto."
    fi

    # Check Zsh
    if [ -L "$USER_HOME/.zshrc" ] && [ "$(readlink "$USER_HOME/.zshrc")" = "$DOTFILES_DIR/.zshrc" ]; then
        echo "✓ .zshrc configurado correctamente."
    else
        echo "✗ .zshrc no está configurado o el enlace simbólico es incorrecto."
    fi

    if [ -L "$USER_HOME/.zsh" ] && [ "$(readlink "$USER_HOME/.zsh")" = "$DOTFILES_DIR/zsh" ]; then
        echo "✓ Directorio zsh configurado correctamente."
    else
        echo "✗ Directorio zsh no está configurado o el enlace simbólico es incorrecto."
    fi

    # Check scripts
    if [ -d "$DOTFILES_DIR/scripts" ] && [ "$(ls -A "$DOTFILES_DIR/scripts")" ]; then
        echo "Validando scripts..."
        for script in "$DOTFILES_DIR/scripts/"*; do
            script_name_with_ext=$(basename "$script")
            script_name_no_ext="${script_name_with_ext%.*}"
            if [ -L "/usr/local/bin/$script_name_no_ext" ] && [ "$(readlink "/usr/local/bin/$script_name_no_ext")" = "$script" ]; then
                echo "✓ Script $script_name_no_ext configurado correctamente."
            else
                echo "✗ Script $script_name_no_ext no está configurado o el enlace simbólico es incorrecto."
            fi
        done
    else
        echo "No hay scripts para validar."
    fi

    echo "Validación completada."
}

while true; do
    echo ""
    echo "Menú de instalación de dotfiles:"
    echo "1. Configurar configuraciones (.config, Neovim, Kitty, VS Code tema, Zsh)"
    echo "2. Configurar scripts (enlaces en /usr/local/bin)"
    echo "3. Ejecutar todo (configuraciones y scripts)"
    echo "4. Validar configuración"
    echo "5. Salir"
    read -p "Elige una opción (1-5): " choice
    case $choice in
        1)
            configure_configs
            ;;
        2)
            configure_scripts
            ;;
        3)
            run_all
            ;;
        4)
            validate_config
            ;;
        5)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida. Intenta de nuevo."
            ;;
    esac
done
