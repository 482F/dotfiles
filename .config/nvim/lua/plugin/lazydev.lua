return {
  'folke/lazydev.nvim',
  ft = 'lua',
  config = function()
    require('lazydev').setup()
  end,
}
