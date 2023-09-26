local util = require('util/init')

return {
  'akinsho/flutter-tools.nvim',
  ft = 'dart',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    {
      '<leader>pud',
      function()
        -- 何故か require('flutter-tools/dev_tools').start() とかを呼んでもうまく行かない
        vim.cmd.FlutterDevTools()
        vim.cmd.FlutterCopyProfilerUrl()
        local url = vim.fn.getreg('*')
        if url ~= nil then
          util.open_url(url)
        end
      end,
      desc = 'devtool を開く',
    },
    {
      '<C-F5>',
      function()
        require('flutter-tools/devices').list_devices()

        local autogroup_id = nil
        autogroup_id = vim.api.nvim_create_autocmd({ 'TextChanged' }, {
          pattern = { '*__FLUTTER_DEV_LOG__' },
          callback = function(event)
            vim.api.nvim_del_autocmd(autogroup_id)
            local console_bufnr = event.buf

            vim.cmd.wincmd('p')
            require('dapui').open()
            vim.api.nvim_win_close(
              vim.fn.win_getid(util.get_winnr_by_bufnr(require('dapui').elements.console.buffer())),
              false
            )

            local console_winnr = util.get_winnr_by_bufnr(console_bufnr)
            vim.fn.win_splitmove(console_winnr, require('dapui').get_main_winnr(), {
              rightbelow = true,
            })

            local console_winid = vim.fn.win_getid(console_winnr)
            vim.api.nvim_win_set_height(console_winid, 10)

            vim.keymap.set('n', '<leader>puc', function()
              vim.fn.win_gotoid(console_winid)
            end, { desc = 'コンソールに移動' })
          end,
        })
      end,
      desc = '起動',
    },
  },
  config = function()
    require('flutter-tools').setup({
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          local dap = require('dap')

          dap.adapters.dart = {
            type = 'executable',
            command = 'cmd.exe',
            args = { '/c', 'flutter', 'debug_adapter' },
            options = {
              detached = false,
            },
          }
          dap.configurations.dart = {
            {
              type = 'dart',
              request = 'launch',
              name = 'Launch Flutter Program',
              program = 'lib/main.dart',
            },
          }
        end,
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
    })
  end,
}
