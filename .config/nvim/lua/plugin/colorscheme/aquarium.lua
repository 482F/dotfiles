return {
  'FrenzyExists/aquarium-vim',
  config = function()
    vim.cmd.colorscheme('aquarium')
    vim.cmd.highlight('Comment', 'guifg=#9CA6B9')
  end,
}
