return {
  'FrenzyExists/aquarium-vim',
  config = function()
    vim.cmd.colorscheme('aquarium')
    vim.cmd.highlight('Comment', 'guifg=#9CA6B9')
    vim.cmd.highlight('DiagnosticHint', 'guifg=#2e2f6b')
    vim.cmd.highlight('Pmenu', 'guibg=#e6e6f1')
    vim.cmd.highlight('StatusLine', 'guibg=#2e2f6b')
    vim.cmd.highlight('StatusLineNC', 'guifg=#2e2f6b')
    vim.cmd.highlight('Cursor', 'guifg=#2e2f6b')
  end,
}
