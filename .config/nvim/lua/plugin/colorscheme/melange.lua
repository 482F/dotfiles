return {
  'savq/melange-nvim',
  config = function()
    vim.cmd.colorscheme('melange')
    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#DED5C2' })
  end,
}
