return {
  'nickburlett/vim-colors-stylus',
  config = function()
    vim.cmd.colorscheme('stylus')
    vim.cmd.highlight('Pmenu', 'guibg=#F1F1F1')
  end,
}
