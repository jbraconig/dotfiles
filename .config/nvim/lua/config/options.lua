-- lua/config/options.lua
local opt = vim.opt -- Para escribir menos
local g = vim.g     -- Para variables globales

-- Apariencia y UI
opt.number = true              -- Muestra números de línea
opt.relativenumber = true      -- Muestra números de línea relativos
opt.termguicolors = true       -- Habilita colores RGB verdaderos (¡esencial para temas modernos!)
opt.showmatch = true           -- Resalta paréntesis/corchetes/llaves coincidentes
opt.showcmd = true             -- Muestra el comando (incompleto) en la última línea
opt.signcolumn = "yes"         -- Siempre muestra la columna de signos (para LSP, GitSigns, etc.)
opt.scrolloff = 8              -- Mantiene 8 líneas de contexto arriba/abajo del cursor
opt.sidescrolloff = 8          -- Mantiene 8 columnas de contexto a los lados del cursor
opt.wrap = false               -- No ajustar líneas largas (preferencia personal)
opt.fillchars = { eob = " " }  -- Evita los '~' al final del buffer, usa espacios en su lugar

-- Comportamiento de Edición
opt.mouse = "a"                -- Habilita el mouse en todos los modos
opt.clipboard = "unnamedplus"  -- Usa el portapapeles del sistema para yank/paste por defecto
opt.expandtab = true           -- Usa espacios en lugar de tabs
opt.tabstop = 4                -- Ancho de una tabulación real (si se usara)
opt.shiftwidth = 4             -- Número de espacios para indentación (IMPORTANTE)
opt.softtabstop = 4            -- Número de espacios que simula la tecla Tab
opt.autoindent = true          -- Copia la indentación de la línea actual a la nueva
opt.smartindent = true         -- Indentación un poco más inteligente para C-like y otros

-- Búsqueda
opt.ignorecase = true          -- Ignorar mayúsculas/minúsculas al buscar
opt.smartcase = true           -- ...a menos que escribas una mayúscula en el patrón
opt.hlsearch = true            -- Resaltar todos los resultados de la búsqueda
opt.incsearch = true           -- Mostrar resultados de búsqueda incrementalmente

-- Undo Persistente
opt.swapfile = false           -- No crear archivos swap
opt.backup = false             -- No crear archivos de backup
opt.undofile = true            -- Habilitar undo persistente entre sesiones
-- Crear directorio para undofiles si no existe
local undodir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

-- Completado (útil para nvim-cmp)
opt.completeopt = "menu,menuone,noselect"

-- Opciones que puedes considerar eliminar o que son por defecto:
-- vim.cmd("syntax enable") -- Tree-sitter lo gestionará mejor
-- vim.cmd("set encoding=utf-8") -- Por defecto en Neovim
-- vim.cmd("set smarttab") -- Con la configuración de tabstop/shiftwidth/softtabstop, no suele ser necesario

-- Asegúrate de que tu tema de colores se aplique *después* de `termguicolors = true`
-- (lazy.nvim lo hace bien si defines `colorscheme` en su `install` o configuras el plugin del tema)