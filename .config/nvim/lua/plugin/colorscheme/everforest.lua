return {
  'neanias/everforest-nvim',
  config = function()
    vim.cmd.colorscheme('everforest')
    require('everforest').setup({
      background = 'hard',
    })
  end,
}
