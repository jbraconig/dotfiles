# 🚀 Mis Dotfiles

Configuración personal para un entorno de desarrollo **Keyboard-Driven**, optimizado para velocidad y ergonomía en Linux.

El objetivo es minimizar el uso del mouse y unificar la lógica de movimiento (`h/j/k/l`) a través de todo el sistema (Terminal, Shell, Editor).

## ⚡ Entorno Principal

*   **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) (Renderizado GPU + Atajos personalizados).
*   **Shell**: **Zsh** + Powerlevel10k + Vi Mode.
*   **Editor**: **Neovim** (LazyVim).
*   **Gestor de Ventanas**: (Opcional, compatible con Tiling WMs).

## 🎮 Guía de Atajos (Cheat Sheet)

### 🐱 Terminal (Kitty)
Gestión de ventanas intuitiva sin tocar el mouse.

| Acción | Atajo | Descripción |
| :--- | :--- | :--- |
| **Focus** | `Alt` + `h/j/k/l` | Mover el foco entre ventanas abiertas. |
| **Move** | `Shift` + `Alt` + `h/j/k/l` | Mover la ventana activa de posición. |
| **Resize** | `Ctrl` + `Alt` + `h/j/k/l` | Redimensionar la ventana activa. |
| **Split** | `Ctrl` + `Shift` + `Enter` | Nueva ventana (mantiene directorio). |
| **Tab** | `Ctrl` + `Shift` + `t` | Nueva pestaña. |

### 🐚 Shell (Zsh - Vi Mode)
La shell opera en modos, igual que Vim.
*   **Modo Normal**: Presiona `ESC`.
*   **Modo Insertar**: Presiona `i` (o escribe directamente).

| Acción (Modo Normal) | Tecla | Descripción |
| :--- | :--- | :--- |
| **Historial** | `k` / `j` | Navegar comandos anteriores/siguientes. |
| **Movimiento** | `h` / `l` | Mover cursor izquierda/derecha. |
| **Palabra** | `w` / `b` | Saltar palabras adelante/atrás. |
| **Editar** | `vv` | Abrir comando actual en **Neovim** para edición completa. |

## 📂 Estructura del Repositorio

*   `.config/`
    *   `kitty/`: Configuración de terminal + mapeos Vim-like.
    *   `nvim/`: Configuración de LazyVim.
*   `.zshrc`: Configuración de shell, plugins y Vi Mode.
*   `install.sh`: Script de despliegue rápido.

## 🛠️ Instalación Rápida

1.  **Clonar**:
    ```bash
    git clone https://github.com/martin/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2.  **Instalar**:
    ```bash
    ./install.sh
    ```

3.  **Dependencias (Debian/Ubuntu)**:
    ```bash
    sudo apt install zsh kitty neovim fzf bat lsd zsh-autosuggestions zsh-syntax-highlighting
    ```

## 🔄 Actualizar

Si haces cambios locales y quieres guardarlos:
```bash
cd ~/dotfiles
git add .
git commit -m "update: mejora configuración"
git push
```
