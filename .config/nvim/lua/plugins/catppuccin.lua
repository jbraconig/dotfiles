-- lua/plugins/catppuccin.lua
return { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    lazy = false, -- Load immediately
    config = function()
        require("catppuccin").setup({
            transparent_background = true,
            flavour = "mocha", -- O "macchiato", "frappe", "latte"
            integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true, -- Si usas nvim-tree en lugar de neo-tree
            neotree = true,  -- Para tu neo-tree.lua
            telescope = true,
            mason = true,
            lsp_trouble = true,
            -- ... y muchos más
            },
        })
        vim.cmd.colorscheme "catppuccin"
    end
}
