vim.cmd.cabbrev('o', 'Oil --float')

return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Oil' },
  lazy = true,
  config = function()
    require('oil').setup({
      keymaps_help = {
        border = 'none',
      },
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name)
          return name == '..'
        end,
      },
      float = {
        padding = 4,
        max_width = 180,
        max_height = 40,
        border = 'none',
      },
    })
  end,
}
