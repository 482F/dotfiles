return {
  'liuchengxu/space-vim-theme',
  config = function()
    vim.cmd.colorscheme('space_vim_theme')
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#E5DCCE' })
  end,
}
