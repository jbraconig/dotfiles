-- lua/config/keymap.lua
local map = vim.keymap.set
local opts = { silent = true } -- noremap = true es por defecto en vim.keymap.set

-- Navegación entre ventanas
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<C-j>', '<C-w>j', opts) -- Añadido para consistencia
map('n', '<C-k>', '<C-w>k', opts) -- Añadido para consistencia

-- Seleccionar todo
map('n', '<C-a>', 'gg<S-v>G', opts)

-- Abrir Oil (explorador de archivos en el buffer actual)
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (Oil)", silent = true })

-- Mover líneas seleccionadas en modo Visual
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Mantener la selección después de indentar en modo Visual
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Guardar
map('n', '<leader>w', '<cmd>w<cr>', { desc = "Save file", silent = true })
map('n', '<leader>q', '<cmd>q<cr>', { desc = "Quit", silent = true })

-- Más keymaps se añadirán a medida que configuremos plugins (LSP, Telescope, etc.)
map('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = "Toggle Neo-tree", silent = true })

-- Keymaps para Telescope (añadir a lua/config/keymap.lua):
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find Files (Telescope)", silent = true })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live Grep (Telescope)", silent = true })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Find Buffers (Telescope)", silent = true })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = "Help Tags (Telescope)", silent = true })
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = "Recent Files (Telescope)", silent = true})