local util = require('util')
local fu = require('util/func')
local stream = require('util/stream')

local main_winnr = nil
---@type integer | nil
local console_winid = nil

local keys = {
  {
    '<leader>ps5',
    function()
      require('dap').step_into()
    end,
    desc = 'ステップイン',
  },
  {
    '<leader>ps6',
    function()
      require('dap').step_over()
    end,
    desc = 'ステップオーバー',
  },
  {
    '<leader>ps7',
    function()
      require('dap').step_out()
    end,
    desc = 'ステップアウト',
  },
  {
    '<leader>ps8',
    function()
      require('dap').continue()
    end,
    desc = 'デバッグ再開',
  },
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
      -- 不要なパラメータまで必須になっているので黙らせる
      ---@diagnostic disable-next-line missing-fields
      require('dapui').float_element('repl', { enter = true })
    end,
    desc = 'REPL 起動',
  },
  {
    '<leader>pue',
    function()
      -- 不要なパラメータまで必須になっているので黙らせる
      ---@diagnostic disable-next-line missing-fields
      require('dapui').eval(nil, { enter = true })
    end,
    desc = 'カーソル下のテキスト評価',
  },
  {
    '<leader>puc',
    function()
      vim.fn.win_gotoid(console_winid)
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
  {
    '<leader>puS',
    function()
      local dap = require('dap')
      vim.ui.select(
        stream
          .start(dap.sessions())
          .filter(fu.is_truthy)
          .sorted(function(a, b)
            return a.value.config.projectName < b.value.config.projectName and -1 or 1
          end)
          .terminate(),
        {
          prompt = 'select session',
          format_item = fu.picker('config', 'name'),
        },
        function(session)
          if not session then
            return
          end

          dap.set_session(session)

          local console_bufnr = stream.find(vim.api.nvim_list_bufs(), function(bufnr)
            return vim.api.nvim_buf_get_name(bufnr):find(session.config.name, 1, true) ~= nil
          end)
          if not console_bufnr or not console_winid then
            return
          end

          vim.api.nvim_win_set_buf(console_winid, console_bufnr)
          vim.api.nvim_win_call(console_winid, function()
            vim.cmd.normal({ args = { 'G' }, bang = true })
          end)
        end
      )
    end,
    desc = 'セッション選択',
  },
}
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
  },
  keys = keys,
  config = function()
    local dapui = require('dapui')
    local dap = require('dap')
    -- 不要なパラメータまで必須になっているので黙らせる
    ---@diagnostic disable-next-line missing-fields
    require('dapui').setup({
      force_buffers = false,
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

    fu.override(dapui, 'open', function(original, ...)
      original(...)
      main_winnr = vim.fn.winnr()
      console_winid = vim.fn.win_getid(util.get_winnr_by_bufnr(require('dapui').elements.console.buffer()))
    end)

    local i = 0
    fu.override(dap, 'run', function(original, ...)
      -- dapui がコンソールのバッファを使い回すのを抑制する
      -- 既存のバッファの判定にバッファ名を使用しているので、バッファ名を変更することで新規バッファを作らせることができる
      local bufnr = require('dapui/elements/console')().buffer()
      i = i + 1
      vim.api.nvim_buf_set_name(bufnr, 'DAP Console' .. tostring(i))

      original(...)

      if not console_winid then
        return
      end
      -- コンソールのウィンドウのバッファを新しく生成したものに切り替える
      vim.api.nvim_win_set_buf(console_winid, require('dapui/elements/console')().buffer())
      vim.api.nvim_win_call(console_winid, function()
        vim.cmd.normal({ args = { 'G' }, bang = true })
      end)
    end)
  end,
  get_main_winnr = function()
    return main_winnr
  end,
}
