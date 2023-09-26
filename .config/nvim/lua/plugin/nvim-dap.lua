local util = require('util/init')
local stream = require('util/stream')

local main_winnr = nil

local function add_sidebar_if_exists()
  local sidebar = util.loadrequire('sidebar-nvim')
  if sidebar == nil then
    return
  end

  sidebar.open()

  local sidebar_bufnr = stream.find(vim.fn.tabpagebuflist(), function(bufnr)
    return vim.fn.bufname(bufnr):find('^SidebarNvim') ~= nil
  end)

  local sidebar_winnr = util.get_winnr_by_bufnr(sidebar_bufnr)
  local watch_winnr = util.get_winnr_by_bufnr(require('dapui').elements.watches.buffer())

  vim.fn.win_splitmove(sidebar_winnr, watch_winnr)
  vim.api.nvim_win_set_height(vim.fn.win_getid(sidebar_winnr), 18)
  vim.api.nvim_win_set_height(vim.fn.win_getid(watch_winnr), 3)
  sidebar.resize(40)
  vim.api.nvim_win_set_width(vim.fn.win_getid(sidebar_winnr), 40)
end

local keys = {
  {
    '<F5>',
    function()
      require('dap').step_into()
    end,
    desc = 'ステップイン',
  },
  {
    '<F6>',
    function()
      require('dap').step_over()
    end,
    desc = 'ステップオーバー',
  },
  {
    '<F7>',
    function()
      require('dap').step_out()
    end,
    desc = 'ステップアウト',
  },
  {
    '<F8>',
    function()
      require('dap').continue()
    end,
    desc = 'デバッグ再開',
  },
  {
    '<leader>pb',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'ブレークポイント切り替え',
  },
  {
    '<leader>plp',
    function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    desc = 'ログポイント設定',
  },
  {
    '<leader>pt',
    function()
      require('dap').terminate()
    end,
    desc = 'デバッグ終了',
  },
  {
    '<leader>puo',
    function()
      require('dapui').open()
    end,
    desc = 'UI オープン',
  },
  {
    '<leader>puC',
    function()
      require('dapui').toggle()
    end,
    desc = 'UI クローズ',
  },
  {
    '<leader>pub',
    function()
      require('dapui').float_element('breakpoints', { width = 80, height = 20, enter = true })
    end,
    desc = 'ブレークポイント一覧表示',
  },
  {
    '<leader>pus',
    function()
      require('dapui').float_element('stacks', { width = 80, height = 20, enter = true })
    end,
    desc = 'スタックトレース表示',
  },
  {
    '<leader>pur',
    function()
      require('dapui').float_element('repl', { enter = true })
    end,
    desc = 'REPL 起動',
  },
  {
    '<leader>pue',
    function()
      require('dapui').eval(nil, { enter = true })
    end,
    desc = 'カーソル下のテキスト評価',
  },
  {
    '<leader>puc',
    function()
      util.focus_by_bufnr(require('dapui').elements.console.buffer())
    end,
    desc = 'コンソールに移動',
  },
  {
    '<leader>pup',
    function()
      util.focus_by_bufnr(require('dapui').elements.scopes.buffer())
    end,
    desc = 'スコープに移動',
  },
  {
    '<leader>puw',
    function()
      util.focus_by_bufnr(require('dapui').elements.watches.buffer())
    end,
    desc = 'ウォッチャーに移動',
  },
  {
    '<leader>pum',
    function()
      local winid = vim.fn.win_getid(main_winnr)
      vim.fn.win_gotoid(winid)
    end,
    desc = 'メインウィンドウに移動',
  },
}
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  keys = keys,
  config = function()
    require('dapui').setup({
      layouts = {
        {
          elements = {
            {
              id = 'scopes',
              size = 0.5,
            },
            {
              id = 'watches',
              size = 0.5,
            },
          },
          position = 'left',
          size = 40,
        },
        {
          elements = {
            {
              id = 'console',
              size = 1,
            },
          },
          position = 'bottom',
          size = 15,
        },
      },
    })
    util.reg_commands(require('dap'), 'dap')
    util.reg_commands(require('dapui'), 'dapui')

    local original_open = require('dapui').open
    local dapui = require('dapui')
    dapui.get_main_winnr = function()
      return main_winnr
    end
    dapui.open = function(...)
      original_open(...)
      add_sidebar_if_exists()
      main_winnr = vim.fn.winnr()
    end
  end,
}
