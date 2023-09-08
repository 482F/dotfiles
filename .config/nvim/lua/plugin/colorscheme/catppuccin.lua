return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'latte',
    })
    vim.cmd.colorscheme('catppuccin')
  end,
}