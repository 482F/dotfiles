local stream = require('util/stream')
return {
  'sidebar-nvim/sidebar.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>st',
      function()
        require('sidebar-nvim').toggle()
      end,
      desc = 'サイドバー開閉',
    },
    {
      '<leader>sf',
      function()
        require('sidebar-nvim').focus()
      end,
      desc = 'サイドバーにフォーカス',
    },
  },
  config = function()
    require('sidebar-nvim').setup({
      disable_default_keybindings = 1,
      bindings = {
        ['d'] = function()
          require('sidebar-nvim/lib').on_keypress('d')
        end,
        ['e'] = function()
          require('sidebar-nvim/lib').on_keypress('e')
        end,
        ['<CR>'] = function()
          require('sidebar-nvim/lib').on_keypress('t')
        end,
      },
      open = false,
      side = 'left',
      initial_width = 25,
      hide_statusline = true,
      update_interval = 10000,
      sections = {
        {
          title = 'keys',
          draw = function(ctx)
            return 'e   : open file\n<CR>: toggle collapse\nd   : close buffer'
          end,
        },
        'buffers',
        'diagnostics',
      },
      section_separator = { '', '-----', '' },
      section_title_separator = { '' },
      todos = { initially_closed = false },
      buffers = {
        ignore_not_loaded = true,
        ignore_terminal = false,
      },
    })
  end,
}
