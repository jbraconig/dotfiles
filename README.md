# My Dotfiles

This repository contains my personal configuration for a development environment on Debian 12 with KDE Plasma (Wayland session). The goal is to quickly replicate my environment on any new machine.

## Main Environment

*   **OS**: Debian 12 (Bookworm)
*   **Desktop Environment**: KDE Plasma (Wayland session)
*   **Terminal**: Kitty
*   **Shell**: Zsh with Powerlevel10k
*   **Editors**: Neovim, Visual Studio Code
*   **Containers**: Docker, Podman
*   **Others**: Git, custom scripts.

## Repository Structure

*   `.zshrc`: Main Zsh configuration.
*   `.p10k.zsh`: Powerlevel10k configuration.
*   `.gitconfig`: Global Git configuration.
*   `.config/`: Contains configurations that follow the XDG specification.
    *   `nvim/`: Full Neovim configuration (Lua).
    *   `kitty/`: Kitty configuration (`kitty.conf` and themes).
    *   `containers/`: Podman configurations (`registries.conf`, `policy.json`).
*   `.vscode/extensions/`:
    *   `kittynordic-theme/`: My custom VS Code theme "Kitty Nordic Theme".
*   `.docker/`:
    *   `config.json`: Docker client configuration (check for credentials before making public).
*   `bin/`: Custom executable scripts to be copied to `/usr/local/bin/`.
*   `intellij_settings/`: Here you can save the exported `.zip` file of your IntelliJ IDEA settings.
*   `install.sh`: Script to create symlinks and set up the environment.
*   `README.md`: This file.
*   `.gitignore`: Specifies files and directories ignored by Git.

## Installation

1.  **Clone the repository**:
    Make sure you have `git` installed.

    ```bash
    git clone https://github.com/jbraconig/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Run the installation script**:
    The script will create symbolic links from the standard configuration locations to the files in this repository. It will also copy scripts to `/usr/local/bin/` (will require `sudo`).

    ```bash
    ./install.sh
    ```

3.  **Manual Post-Installation Steps**:

    *   **Restart Terminal/Shell**: Open a new Kitty instance or run `source ~/.zshrc` to apply the Zsh configuration.
    *   **Install Base Software**: This script does not install applications (Neovim, Kitty, VS Code, Docker, Podman, Zsh, etc.). Make sure they are installed beforehand.
        *   On Debian, for example:
            ```bash
            sudo apt update
            sudo apt install zsh git neovim kitty code docker.io podman curl wget build-essential
            ```
    *   **Neovim Plugins**: Open Neovim. If you use a plugin manager like `lazy.nvim`, plugins should install automatically. You may need to run a specific command for your manager (e.g., `:LazySync`).
    *   **VS Code Extensions**:
        *   The `kittynordic-theme` will be linked.
        *   Other extensions may need to be installed manually or synced if you use VS Code settings sync.
    *   **IntelliJ IDEA**: Manually import the configuration from the `.zip` file saved in `intellij_settings/` (File -> Manage IDE Settings -> Import Settings...).
    *   **Fonts**: Make sure you have the necessary fonts installed for Powerlevel10k (e.g., MesloLGS NF) and for your Kitty/Neovim configuration.

## Update Configurations

1.  Make changes to the configuration files directly on your system (these changes will be reflected in the files inside `~/dotfiles` due to the symlinks).
2.  Go to the `~/dotfiles` directory:
    ```bash
    cd ~/dotfiles
    ```
3.  Add the changes, commit, and push them to GitHub:
    ```bash
    git add .
    git commit -m "Update description"
    git push origin main
    ```
4.  On other machines, go to `~/dotfiles` and run `git pull` to get the updates. If you added new files that require symlinks, you may need to re-run parts of `install.sh` or the entire script (it is designed to be safe to re-run with `ln -sf`).

## Contributions

This is my personal dotfiles repository, but if you have suggestions or improvements, feel free to open an issue or pull request!
