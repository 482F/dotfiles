vim.cmd.cabbrev('o', 'Oil --float')

return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Oil' },
  lazy = true,
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
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
