return {
  'xiyaowong/telescope-emoji.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>te',
      function()
        return require('telescope').extensions.emoji.emoji()
      end,
      desc = 'emoji',
    },
  },
}
