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
    -- treesitter の diff ハイライトに対応していないカラースキームが多いのでそれの対応
    vim.cmd.highlight('def', 'link', '@text.diff.add', 'DiffAdded')
    vim.cmd.highlight('def', 'link', '@text.diff.delete', 'DiffRemoved')
  end,
}
