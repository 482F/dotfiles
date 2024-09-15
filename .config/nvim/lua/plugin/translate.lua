return {
  'uga-rosa/translate.nvim',
  keys = {
    {
      '<leader><leader>tr',
      function()
        vim.fn.feedkeys('gv', 'nx') -- 一つ前の選択範囲が翻訳されるので、同じ範囲を選択しなおす
        require('translate').translate('V', { 'ja' })
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
