return {
  'uga-rosa/translate.nvim',
  keys = {
    {
      '<leader><leader>tr',
      function()
        vim.cmd.Translate({ args = { 'ja' } })
      end,
      mode = 'x',
      desc = '選択範囲を翻訳',
    },
  },

  config = function()
    require('translate').setup({
      default = {},
      preset = {
        output = {
          split = {
            append = true,
          },
        },
      },
    })
  end,
}
