local util = require('util/init')

---@param bufnr integer
local function focus_by_bufnr(bufnr)
  local winnr = (function()
    local tabpagenr = vim.fn.tabpagenr()
    local last_winnr = vim.fn.tabpagewinnr(tabpagenr, '$')

    for i = 1, last_winnr, 1 do
      if bufnr == vim.fn.winbufnr(i) then
        return i
      end
    end
  end)()
  local winid = vim.fn.win_getid(winnr)
  vim.fn.win_gotoid(winid)
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
    '<leader>put',
    function()
      require('dapui').toggle()
    end,
    desc = 'UI オープン',
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
      focus_by_bufnr(require('dapui').elements.console.buffer())
    end,
    desc = 'コンソールに移動',
  },
  {
    '<leader>pup',
    function()
      focus_by_bufnr(require('dapui').elements.scopes.buffer())
    end,
    desc = 'スコープに移動',
  },
  {
    '<leader>puw',
    function()
      focus_by_bufnr(require('dapui').elements.watches.buffer())
    end,
    desc = 'ウォッチャーに移動',
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
  end,
}
