return {
  'nvim-lua/plenary.nvim',
  lazy = true,
  keys = {
    {
      '<leader>rt',
      function()
        local path = vim.fn.expand('%:p')
        if not path:match('_spec%.lua$') then
          path = path:match('^(.+)%.lua$') .. '_spec.lua'
        end
        require('plenary/test_harness').test_file(path)
      end,
      desc = 'カレントファイルをテスト',
    },
    {
      '<leader>rT',
      function()
        require('plenary/test_harness').test_directory(vim.fn.stdpath('config') .. '/lua')
      end,
      desc = 'nvim config をテスト',
    },
  },
  config = function() end,
}
