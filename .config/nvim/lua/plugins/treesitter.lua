local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Actualiza parsers al instalar/actualizar
    event = { "BufReadPost", "BufNewFile" }, -- Carga cuando abres un archivo
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
}

return { M }
