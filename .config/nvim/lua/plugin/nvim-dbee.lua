return {
  'kndndrj/nvim-dbee',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  keys = {
    {
      '<leader>dt',
      function()
        -- 一回目はエラーになる
        pcall(require('dbee').open)
        pcall(require('dbee').open)
      end,
      desc = 'dbee を開く',
    },
  },
  build = function()
    require('dbee').install('curl')
  end,
  config = function()
    local pass = nil
    local original_dbee_register_connection = vim.fn.Dbee_register_connection

    -- UI を開いた時にパスワードを入力する
    -- TODO: 接続先ごとにパスワードを入力できるようにしたい
    -- - 現時点では最初にコネクションの定義を go の方に渡し、UI から開くときには ID のみを投げることでコネクションを読み出している
    -- - そのため、開いたタイミングでパスワードを入力するようにはできない
    -- - 開いたタイミングで既存のコネクションを改変し再登録、再度開くとか？
    vim.fn.Dbee_register_connection = function(id, url, type, size)
      if not url:find('password') then
        if pass == nil then
          pass = vim.fn.inputsecret('Enter db password: ')
        end
        url = url .. '&password=' .. pass
      end
      return original_dbee_register_connection(id, url, type, size)
    end
    require('dbee').setup({})
  end,
}
