return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  config = function()
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      highlight = {
        enable = true, -- syntax highlightを有効にする
        disable = {},
      },
    })
  end,
}
