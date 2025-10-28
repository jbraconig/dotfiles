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
*   `plugins-zsh/`: Plugins personalizados para Zsh.
*   `.zshrc`: Configuración de Zsh.

## Instalación

1.  **Clonar el repositorio**:
    Asegúrate de tener `git` instalado.

    ```bash
    git clone https://github.com/martin/dotfiles.git ~/dotfiles
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


Programas:
    zsh: plugins zsh-autosuggestions, zsh-history-substring-search , fzf y zsh-syntax-highlighting.
    Angular.
    node.
    lsd.
    bat.
    vscode.
    Idea JetBrains Community (Se ejecuta desde Applications/idea-IC-242.21829.142, hay que crear el .desktop).
    gotdot (Se ejecuta desde /Applications/godot, hay que crear el .desktop).
    podman.
    blender
    obs.
    bruno.

## Instalación de Programas

Para instalar los programas listados anteriormente en Debian 13, ejecuta los siguientes comandos. Asegúrate de tener `sudo` configurado y actualiza los paquetes primero con `sudo apt update`.

### Zsh y plugins
```bash
sudo apt install zsh zsh-autosuggestions zsh-history-substring-search fzf zsh-syntax-highlighting
```

### Node.js y Angular
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g @angular/cli
```

### Herramientas adicionales
```bash
sudo apt install bat podman blender obs-studio
```

### LSD
Descarga la última versión desde https://github.com/lsd-rs/lsd/releases y extrae el binario a `/usr/local/bin/`, o instala via Cargo si tienes Rust:
```bash
cargo install lsd
```

### VS Code
Añade el repositorio de Microsoft y instala:
```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

### IntelliJ IDEA Community
Descarga desde https://www.jetbrains.com/idea/download/?section=linux y sigue las instrucciones de instalación.

### Godot
Descarga desde https://godotengine.org/download/linux/ y extrae el archivo.

### Bruno
Descarga desde https://www.usebruno.com/downloads y sigue las instrucciones de instalación.
