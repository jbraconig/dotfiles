# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Funtions
zle -N fzf-history-widget
bindkey '^f' fzf-history-widget

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey "^[[1;2C" forward-word
bindkey "^[[1;2D" backward-word
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey '^w' backward-kill-word
bindkey '^u' kill-whole-line
bindkey '^t' transpose-chars
bindkey '^l' clear-screen

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# PATH
export JAVA_HOME=/home/martin/.jdks/corretto-17.0.16
export JAVA_BIN=$JAVA_HOME/bin
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="$PATH:/usr/local/go/bin:$JAVA_HOME:$JAVA_BIN:$HOME/.local/bin"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:/opt/nvim

# usar bat como pager para man y otras herramientas
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export PAGER="batcat -p"
# Ejemplo de personalización en ~/.zshrc (colocar ANTES de la función)
export _FZF_OPEN_EDITOR="code"
export _FZF_OPEN_FIND_EXCLUDE_DIRS=(".git" "node_modules" "vendor" "dist" "__pycache__" ".DS_Store")
export _FZF_OPEN_PREVIEW_THEME="Dracula"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias icat="kitty +kitten icat"
alias cat='batcat'
[ "$TERM" = "xterm-kitty" ] && alias ssh='kitty +kitten ssh'


# Plugins
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
source <(ng completion script)

# zoxide para saltar entre directoriso rápidamente
eval "$(zoxide init zsh --cmd z)"

# Opcional: Integración de fzf para zoxide (para un fx "interactivo")
# Esto te permite buscar directorios con fzf y saltar a ellos.
_zoxide_fzf_complete() {
    local cur
    cur=${(q)CONTEXT}
    local IFS=$'\n'
    compadd -o default - "${(f)$(zoxide query -l "${cur}" | fzf --filter="${cur}" --no-info --height=20%)}"
}
zstyle ':completion:*' menu select=2
zstyle ':completion:*:functions:*:cd:*' completer _zoxide_fzf_complete
zstyle ':completion:*:functions:*:_cd:*' completer _zoxide_fzf_complete

# MI FUNCIÓN PERSONALIZADA Y BINDING PARA CTRL+O
# ------------------------------------------------------------------------------
# fzf-open-file: Busca y abre archivos con fzf y tu editor preferido.
# ...
# ------------------------------------------------------------------------------
fzf-open-file() {
    local editor_cmd find_cmd preview_cmd selected_output fzf_exit_code
    local -a files_to_open # Zsh: declara un array

    # 1. Determinar el editor a usar
    if [[ -n "$_FZF_OPEN_EDITOR" ]] && command -v "$_FZF_OPEN_EDITOR" &>/dev/null; then
        editor_cmd="$_FZF_OPEN_EDITOR"
    elif command -v code &>/dev/null; then
        editor_cmd="code"
    elif [[ -n "$EDITOR" ]] && command -v "$EDITOR" &>/dev/null; then
        editor_cmd="$EDITOR"
    else
        echo "fzf-open-file: Editor no encontrado." >&2
        echo "Por favor, define _FZF_OPEN_EDITOR, instala 'code', o define la variable \$EDITOR." >&2
        return 1
    fi

    # 2. Determinar el comando de búsqueda de archivos
    if command -v fd &>/dev/null; then
        local -a fd_opts_array # Usar un nombre diferente para el array
        # Si _FZF_OPEN_FD_OPTIONS es una cadena, divídela en un array
        if [[ -n "$_FZF_OPEN_FD_OPTIONS" ]]; then
            fd_opts_array=(${(z)_FZF_OPEN_FD_OPTIONS}) # (z) para dividir como la shell
        else
             # Opciones por defecto para fd si _FZF_OPEN_FD_OPTIONS no está seteada
            fd_opts_array=(--type f --hidden --follow) # Quitar --color=never aquí
        fi
        # Asegurar que --color=never esté presente para evitar problemas de parseo con fzf
        # y evitar duplicados si el usuario ya lo puso
        if ! ( printf '%s\n' "${fd_opts_array[@]}" | grep -q -x -e '--color=never' -e '--colour=never' ); then
            fd_opts_array+=(--color=never)
        fi
        find_cmd="fd ${fd_opts_array[@]}"
    else
        local -a exclude_opts
        local default_exclude_dirs=(".git" "node_modules" "target" ".cache" "vendor" "build" "dist" ".venv" "__pycache__")
        local current_exclude_dirs
        
        if [[ -n "${_FZF_OPEN_FIND_EXCLUDE_DIRS[*]}" ]]; then
            current_exclude_dirs=("${_FZF_OPEN_FIND_EXCLUDE_DIRS[@]}")
        else
            current_exclude_dirs=("${default_exclude_dirs[@]}")
        fi

        for dir in "${current_exclude_dirs[@]}"; do
            exclude_opts+=(-name "$dir" -o)
        done
        # Quitar el último '-o'
        if [[ ${#exclude_opts[@]} -gt 0 ]]; then
            # El último elemento es '-o', queremos reemplazarlo con -prune
            # y quitar el penúltimo (el -name "$dir") si solo hay una exclusión
            # Es más simple construir la cadena de forma diferente
            local find_exclude_str
            for dir in "${current_exclude_dirs[@]}"; do
                find_exclude_str+="-name \"$dir\" -o "
            done
            # Quitar el último " -o "
            find_exclude_str=${find_exclude_str% -o }
            
            if [[ -n "$find_exclude_str" ]]; then
              find_cmd="find . \( $find_exclude_str \) -prune -o -type f -print"
            else
              find_cmd="find . -type f -print"
            fi
        else
            find_cmd="find . -type f -print" # Sin exclusiones si el array está vacío
        fi
    fi

    # 3. Determinar el comando de previsualización
    local preview_theme_opt
    if [[ -n "$_FZF_OPEN_PREVIEW_THEME" ]]; then
        preview_theme_opt="--theme=$_FZF_OPEN_PREVIEW_THEME"
    fi

    if command -v batcat &>/dev/null; then
        preview_cmd="batcat --color=always --line-range :200 $preview_theme_opt {}"
    elif command -v bat &>/dev/null; then
        preview_cmd="bat --color=always --line-range :200 $preview_theme_opt {}"
    else
        preview_cmd="head -n 200 {}"
    fi

    # 4. Ejecutar fzf
    # Redirigir stderr del comando de búsqueda a /dev/null para evitar mensajes de error (ej. permisos denegados).
    # El comando de búsqueda se ejecuta con `eval` para manejar correctamente las cadenas complejas y arrays.
    # Cuidado con `eval` si los comandos pueden venir de fuentes no confiables.
    # Aquí, $find_cmd es construido internamente, así que debería ser seguro.
    if ! selected_output=$(eval "$find_cmd" 2>/dev/null | \
        fzf --multi \
            --preview "$preview_cmd" \
            --height=40% --layout=reverse \
            --prompt="Abrir Archivo(s) > "); then
        
        fzf_exit_code=$?
        if [[ $fzf_exit_code -eq 1 ]]; then
            # echo "fzf-open-file: No se encontraron coincidencias." # Opcional
        elif [[ $fzf_exit_code -eq 130 ]]; then
            # echo "fzf-open-file: Operación cancelada." # Opcional
        else
            # echo "fzf-open-file: Error de fzf (código $fzf_exit_code) o comando de búsqueda falló." >&2
        fi
        # return $fzf_exit_code # No siempre deseable devolver !=0 por cancelación
        return 0 # Tratar cancelaciones/no-match como "sin acción" pero no error
    fi

    if [[ -z "$selected_output" ]]; then
        return 0
    fi

    # 5. Convertir la salida de fzf (separada por saltos de línea) en un array
    local IFS=$'\n'
    files_to_open=(${(f)selected_output}) # Zsh specific: (f) flag splits by newline
    unset IFS

    if [[ ${#files_to_open[@]} -eq 0 ]]; then
        return 0
    fi

    # 6. Abrir los archivos seleccionados
    "$editor_cmd" "${files_to_open[@]}"
    return $?
}

zle -N fzf-open-file
bindkey '^o' fzf-open-file
