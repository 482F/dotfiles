local util = require('util/init')

local keys = {
  {
    '<F7>',
    function()
      require('dap').step_into()
    end,
    { desc = 'ステップイン' },
  },
  {
    '<F8>',
    function()
      require('dap').step_over()
    end,
    { desc = 'ステップオーバー' },
  },
  {
    '<F9>',
    function()
      require('dap').step_out()
    end,
    { desc = 'ステップアウト' },
  },
  {
    '<Leader>db',
    function()
      require('dap').toggle_breakpoint()
    end,
    { desc = 'ブレークポイント切り替え' },
  },
  {
    '<Leader>dlp',
    function()
      require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    { desc = 'ログポイント設定' },
  },
  {
    '<Leader>dr',
    function()
      require('dap').repl.open()
    end,
    { desc = 'REPL' },
  },
  {
    '<Leader>du',
    function()
      require('dapui').toggle()
    end,
    { desc = 'UI オープン' },
  },
  {
    '<Leader>dt',
    function()
      require('dap').terminate()
    end,
    { desc = 'デバッグ終了' },
  },
}
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
  },
  keys = keys,
  config = function()
    require('dapui').setup()
    util.reg_commands(require('dap'), 'dap')
    util.reg_commands(require('dapui'), 'dapui')
  end,
}
