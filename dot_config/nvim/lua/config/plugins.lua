return
{
    { 'folke/tokyonight.nvim' },

    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies =
        {
            -- LSP Support
            {"neovim/nvim-lspconfig"}, --:sh, gd,gi,gs,gr,K,<l>ca,<l>cd,<l>rf,[e,]e, UNUSED: <l>wa/wr/wl/q/f (workspace folders, loclist, formatting)
            -- Autocompletion
            {"hrsh7th/nvim-cmp"},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-nvim-lua"},
            -- Snippets
            {"L3MON4D3/LuaSnip"},
            {"rafamadriz/friendly-snippets"},
        }
    },

    { 'jose-elias-alvarez/null-ls.nvim' },

    { "nvim-telescope/telescope.nvim", dependencies = { { "nvim-lua/popup.nvim", lazy = false }, { "nvim-lua/plenary.nvim", lazy = false } } },
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    { "mizlan/iswap.nvim" }, --:Iswap, as mapping :ISwapWith
}
