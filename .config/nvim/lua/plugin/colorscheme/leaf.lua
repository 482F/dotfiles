return {
  'daschw/leaf.nvim',
  config = function()
    vim.cmd.colorscheme('leaf')

    local sl = vim.api.nvim_get_hl(0, { name = 'StatusLineNc' })
    sl.fg = '#000000'
    vim.api.nvim_set_hl(0, 'StatusLineNc', sl)
  end,
}
