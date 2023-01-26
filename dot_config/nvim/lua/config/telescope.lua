local ok_telescope, telescope = pcall(require, 'telescope')
if not ok_telescope then
  return
end

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
}
