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

configure_plugins() {
    echo "Configurando plugins de Zsh..."

    # Zsh Autosuggestions
    if [ ! -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        echo "Instalando zsh-autosuggestions..."
        sudo mkdir -p "/usr/share/zsh-autosuggestions"
        sudo ln -sf "$DOTFILES_DIR/plugins-zsh/zsh-autosuggestions.zsh" "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    else
        echo "zsh-autosuggestions ya está instalado."
    fi

    # Zsh History Substring Search
    if [ ! -f "/usr/share/zsh/plugins/zsh-history-substring-search.zsh" ]; then
        echo "Instalando zsh-history-substring-search..."
        sudo mkdir -p "/usr/share/zsh/plugins"
        sudo ln -sf "$DOTFILES_DIR/plugins-zsh/zsh-history-substring-search.zsh" "/usr/share/zsh/plugins/zsh-history-substring-search.zsh"
    else
        echo "zsh-history-substring-search ya está instalado."
    fi

    # Powerlevel10k
    if [ ! -d "$USER_HOME/powerlevel10k" ]; then
        echo "Instalando Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$USER_HOME/powerlevel10k"
    else
        echo "Powerlevel10k ya está instalado."
    fi


    # Zsh Syntax Highlighting
    if [ ! -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        echo "Instalando zsh-syntax-highlighting..."
        sudo mkdir -p "/usr/share/zsh-syntax-highlighting"
        sudo ln -sf "$DOTFILES_DIR/plugins-zsh/zsh-syntax-highlighting.zsh" "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    else
        echo "zsh-syntax-highlighting ya está instalado."
    fi

    echo "Configuración de plugins completada."
}

configure_system() {
    if [ -f "$DOTFILES_DIR/setup_amd_debian13.sh" ]; then
        echo "Configuración del sistema (Dependencias, Fuentes, Drivers AMD) para Debian 13..."
        read -p "¿Deseas ejecutar la configuración del sistema AMD usando sudo? (s/N): " response
        if [[ "$response" =~ ^([sS][iI]?|[yY])$ ]]; then
            bash "$DOTFILES_DIR/setup_amd_debian13.sh"
        else
            echo "Se omitió la configuración del sistema AMD."
        fi
    else
        echo "Script de configuración del sistema no encontrado: $DOTFILES_DIR/setup_amd_debian13.sh"
    fi
}

run_all() {
    configure_configs
    configure_scripts
    configure_plugins
    configure_system
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

    # Check Zsh plugins
    if [ -L "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && [ "$(readlink "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh")" = "$DOTFILES_DIR/plugins-zsh/zsh-autosuggestions.zsh" ]; then
        echo "✓ zsh-autosuggestions configurado correctamente."
    elif [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
        echo "✓ zsh-autosuggestions instalado (no es enlace de dotfiles)."
    else
        echo "✗ zsh-autosuggestions no está instalado."
    fi

    if [ -L "/usr/share/zsh/plugins/zsh-history-substring-search.zsh" ] && [ "$(readlink "/usr/share/zsh/plugins/zsh-history-substring-search.zsh")" = "$DOTFILES_DIR/plugins-zsh/zsh-history-substring-search.zsh" ]; then
        echo "✓ zsh-history-substring-search configurado correctamente."
    elif [ -f "/usr/share/zsh/plugins/zsh-history-substring-search.zsh" ]; then
        echo "✓ zsh-history-substring-search instalado (no es enlace de dotfiles)."
    else
        echo "✗ zsh-history-substring-search no está instalado."
    fi

    if [ -d "$USER_HOME/powerlevel10k" ] && [ -f "$USER_HOME/powerlevel10k/powerlevel10k.zsh-theme" ]; then
        echo "✓ Powerlevel10k configurado correctamente."
    else
        echo "✗ Powerlevel10k no está instalado."
    fi


    if [ -L "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && [ "$(readlink "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")" = "$DOTFILES_DIR/plugins-zsh/zsh-syntax-highlighting.zsh" ]; then
        echo "✓ zsh-syntax-highlighting configurado correctamente."
    elif [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
        echo "✓ zsh-syntax-highlighting instalado (no es enlace de dotfiles)."
    else
        echo "✗ zsh-syntax-highlighting no está instalado."
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
    echo "2. Configurar plugins de Zsh"
    echo "3. Configurar sistema AMD (Debian 13)"
    echo "4. Configurar scripts (enlaces en /usr/local/bin)"
    echo "5. Ejecutar todo (configuraciones, plugins, sistema y scripts)"
    echo "6. Validar configuración"
    echo "7. Salir"
    read -p "Elige una opción (1-7): " choice
    case $choice in
        1)
            configure_configs
            ;;
        2)
            configure_plugins
            ;;
        3)
            configure_system
            ;;
        4)
            configure_scripts
            ;;
        5)
            run_all
            ;;
        6)
            validate_config
            ;;
        7)
            echo "Saliendo..."
            exit 0
            ;;
        *)
            echo "Opción inválida. Intenta de nuevo."
            ;;
    esac
done
