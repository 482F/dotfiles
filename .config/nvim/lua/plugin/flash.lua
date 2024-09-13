local stream = require('util/stream')
local overwritten_keys = { 'f', 'F', 't', 'T' }

return {
  'folke/flash.nvim',
  lazy = true,
  keys = stream
    .start(overwritten_keys)
    .map(function(key)
      return {
        key,
        mode = { 'n', 'x', 'o' },
      }
    end)
    .inserted_all({
      {
        'ss',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'flash',
      },
      {
        'sr',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'flash remote',
      },
      {
        'st',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'flash treesitter search',
      },
    })
    .terminate(),
  config = function()
    vim.api.nvim_set_hl(
      0,
      'FlashLabel',
      stream.inserted_all(vim.api.nvim_get_hl(0, { name = 'Search' }), { bg = '#ffffff', fg = '#000000' })
    )
    require('flash').setup({
      modes = {
        treesitter = {
          search = { incremental = true },
        },
        treesitter_search = {
          search = { incremental = true },
        },
        search = { enabled = false },
        char = {
          char_actions = function()
            return {
              [';'] = 'next',
              [','] = 'prev',
              -- [motion:lower()] = 'right',
              -- [motion:upper()] = 'left',
            }
          end,
        },
      },
    })
  end,
}
