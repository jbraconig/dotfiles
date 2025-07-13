# Mis Dotfiles

Este repositorio contiene mi configuración personal para un entorno de desarrollo. El objetivo es replicar rápidamente mi entorno en cualquier máquina nueva.

## Entorno Principal

*   **Terminal**: Kitty
*   **Editores**: Neovim, Visual Studio Code
*   **Otros**: Git, scripts personalizados.

## Estructura del Repositorio

*   `.config/`: Contiene configuraciones que siguen la especificación XDG.
    *   `nvim/`: Configuración completa de Neovim (Lua).
    *   `kitty/`: Configuración de Kitty (`kitty.conf`).
*   `.vscode/extensions/`:
    *   `kittynordic-theme/`: Mi tema personalizado de VS Code "Kitty Nordic Theme".
*   `scripts/`: Scripts ejecutables personalizados para ser enlazados simbólicamente en `/usr/local/bin/`.
*   `install.sh`: Script para crear enlaces simbólicos y configurar el entorno.
*   `README.md`: Este archivo.
*   `.gitignore`: Especifica archivos y directorios ignorados por Git.

## Instalación

1.  **Clonar el repositorio**:
    Asegúrate de tener `git` instalado.

    ```bash
    git clone https://github.com/jbraconig/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Ejecutar el script de instalación**:
    El script creará enlaces simbólicos desde las ubicaciones de configuración estándar a los archivos de este repositorio. También ofrecerá crear enlaces simbólicos para los scripts en `/usr/local/bin/` (requerirá `sudo`).

    ```bash
    ./install.sh
    ```

3.  **Pasos Manuales Post-Instalación**:

    *   **Reiniciar la Terminal**: Abre una nueva instancia de Kitty para aplicar la configuración.
    *   **Instalar Software Base**: Este script no instala aplicaciones (Neovim, Kitty, VS Code, Git, etc.). Asegúrate de que estén instaladas de antemano.
    *   **Plugins de Neovim**: Abre Neovim. Si usas un gestor de plugins como `lazy.nvim`, los plugins deberían instalarse automáticamente. Puede que necesites ejecutar un comando específico para tu gestor (ej. `:LazySync`).
    *   **Extensiones de VS Code**:
        *   El tema `kittynordic-theme` será enlazado.
        *   Otras extensiones pueden necesitar ser instaladas manually o sincronizadas si usas la sincronización de configuración de VS Code.
    *   **Fuentes**: Asegúrate de tener instaladas las fuentes necesarias para tu configuración de Kitty/Neovim.

## Actualizar Configuraciones

1.  Realiza cambios en los archivos de configuración directamente en tu sistema (estos cambios se reflejarán en los archivos dentro de `~/dotfiles` debido a los enlaces simbólicos).
2.  Ve al directorio `~/dotfiles`:

    ```bash
    cd ~/dotfiles
    ```

3.  Añade los cambios, haz commit y súbelos a tu repositorio:

    ```bash
    git add .
    git commit -m "Describir actualización"
    git push origin main
    ```

4.  En otras máquinas, ve a `~/dotfiles` y ejecuta `git pull` para obtener las actualizaciones. Si añadiste nuevos archivos que requieren enlaces simbólicos, puede que necesites volver a ejecutar partes de `install.sh` o el script completo (está diseñado para ser seguro de re-ejecutar con `ln -sf`).

## Contribuciones

Este es mi repositorio personal de dotfiles, pero si tienes sugerencias o mejoras, ¡siéntete libre de abrir un issue o un pull request!
