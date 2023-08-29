return {
  'kylechui/nvim-surround',
  config = function()
    require('nvim-surround').setup({})
  end,
  keys = {
    { 'ySS', mode = 'n' },
    { 'yS', mode = 'n' },
    { 'cS', mode = 'n' },
    { 'yss', mode = 'n' },
    { 'ys', mode = 'n' },
    { 'ds', mode = 'n' },
    { 'cs', mode = 'n' },
    { 'gS', mode = 'x' },
    { 'S', mode = 'x' },
    { '<C-g>s', mode = 'i' },
    { '<C-g>S', mode = 'i' },
  },
}
