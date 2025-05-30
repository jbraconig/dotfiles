# Mis Dotfiles

Este repositorio contiene mi configuración personal para un entorno de desarrollo en Debian 12 con KDE Plasma (sesión Wayland). El objetivo es poder replicar rápidamente mi entorno en cualquier máquina nueva.

## Entorno Principal

*   **SO**: Debian 12 (Bookworm)
*   **Entorno de Escritorio**: KDE Plasma (sesión Wayland)
*   **Terminal**: Kitty
*   **Shell**: Zsh con Powerlevel10k
*   **Editores**: Neovim, Visual Studio Code
*   **Contenedores**: Docker, Podman
*   **Otros**: Git, scripts personalizados.

## Estructura del Repositorio

*   `.zshrc`: Configuración principal de Zsh.
*   `.p10k.zsh`: Configuración de Powerlevel10k.
*   `.gitconfig`: Configuración global de Git.
*   `.config/`: Contiene configuraciones que siguen la especificación XDG.
    *   `nvim/`: Configuración completa de Neovim (Lua).
    *   `kitty/`: Configuración de Kitty (`kitty.conf` y temas).    
    *   `containers/`: Configuraciones de Podman (`registries.conf`, `policy.json`).
*   `.vscode/extensions/`:
    *   `kittynordic-theme/`: Mi tema personalizado para VS Code "Kitty Nordic Theme".
*   `.docker/`:
    *   `config.json`: Configuración del cliente Docker (revisar por credenciales antes de hacer público).
*   `bin/`: Scripts ejecutables personalizados que se copiarán a `/usr/local/bin/`.
*   `intellij_settings/`: Aquí se puede guardar el archivo `.zip` exportado de la configuración de IntelliJ IDEA.
*   `install.sh`: Script para crear los symlinks y configurar el entorno.
*   `README.md`: Este archivo.
*   `.gitignore`: Especifica los archivos y directorios ignorados por Git.

## Instalación

1.  **Clonar el repositorio**:
    Asegúrate de tener `git` instalado.

    ```bash
    git clone https://github.com/jbraconig/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```    

2.  **Ejecutar el script de instalación**:
    El script creará enlaces simbólicos desde las ubicaciones estándar de configuración hacia los archivos en este repositorio. También copiará scripts a `/usr/local/bin/` (requerirá `sudo`).

    ```bash
    ./install.sh
    ```

3.  **Pasos Post-Instalación Manuales**:

    *   **Reiniciar Terminal/Shell**: Abre una nueva instancia de Kitty o ejecuta `source ~/.zshrc` para aplicar la configuración de Zsh.
    *   **Instalar Software Base**: Este script no instala las aplicaciones (Neovim, Kitty, VS Code, Docker, Podman, Zsh, etc.). Asegúrate de que estén instaladas previamente.
        *   En Debian, por ejemplo:
            ```bash
            sudo apt update
            sudo apt install zsh git neovim kitty code docker.io podman curl wget build-essential
            ```
    *   **Neovim Plugins**: Abre Neovim. Si usas un gestor de plugins como `lazy.nvim`, los plugins deberían instalarse automáticamente. Puede que necesites ejecutar un comando específico del gestor (ej. `:LazySync`).
    *   **VS Code Extensiones**:
        *   El tema `kittynordic-theme` se enlazará.
        *   Otras extensiones pueden necesitar ser instaladas manualmente o sincronizadas si usas la sincronización de settings de VS Code.
    *   **IntelliJ IDEA**: Importa manualmente la configuración desde el archivo `.zip` guardado en `intellij_settings/` (File -> Manage IDE Settings -> Import Settings...).
    *   **Fuentes**: Asegúrate de tener instaladas las fuentes necesarias para Powerlevel10k (ej. MesloLGS NF) y para tu configuración de Kitty/Neovim.
    *   **Configuración de KDE/Wayland**:
        *   Temas, iconos, cursores, paneles, atajos de teclado de KDE se configuran a través de las "Preferencias del Sistema" de KDE. Este repositorio no gestiona esos archivos directamente debido a su complejidad y dinamismo. Documenta tus preferencias aquí o usa herramientas de exportación de perfiles de KDE si están disponibles.
        *   Configuraciones específicas de Wayland pueden depender del gestor de pantalla (SDDM) o configuraciones de KWin.

## Actualizar Configuraciones

1.  Realiza cambios en los archivos de configuración directamente en tu sistema (estos cambios se reflejarán en los archivos dentro de `~/dotfiles` debido a los symlinks).
2.  Ve al directorio `~/dotfiles`:
    ```bash
    cd ~/dotfiles
    ```
3.  Añade los cambios, haz commit y súbelos a GitHub:
    ```bash
    git add .
    git commit -m "Descripción de la actualización"
    git push origin main
    ```
4.  En otras máquinas, ve a `~/dotfiles` y ejecuta `git pull` para obtener las actualizaciones. Si añadiste nuevos archivos que requieren symlinks, puede ser necesario re-ejecutar partes de `install.sh` o el script completo (está diseñado para ser seguro re-ejecutarlo con `ln -sf`).

## Contribuciones

Este es mi repositorio personal de dotfiles, pero si tienes sugerencias o mejoras, ¡no dudes en abrir un issue o un pull request!