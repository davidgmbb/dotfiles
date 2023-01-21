require('config.options')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local has_lazy = vim.loop.fs_stat(lazypath)
if not has_lazy then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup('config.plugins', {})
require('config.treesitter')
require('config.telescope')
require('config.lsp')

vim.cmd[[colorscheme tokyonight]]


local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>d', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>f', telescope_builtin.git_files, {})
vim.keymap.set('n', '<leader>g', function()
	telescope_builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
