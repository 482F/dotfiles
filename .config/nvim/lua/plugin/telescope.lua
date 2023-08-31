local util = require('util/init')

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('util/init').reg_commands(util.lazy_require('telescope.builtin'), 'telescope')
  end,
  keys = {
    {
      '<leader>to',
      function()
        util.lazy_require('telescope.builtin').find_files()
      end,
    },
    {
      '<leader>tk',
      function()
        require('telescope.builtin').keymaps()
      end,
    },
    {
      '<leader>tg',
      function()
        util.lazy_require('telescope.builtin').live_grep()
      end,
    },
    {
      '<leader>tb',
      function()
        util.lazy_require('telescope.builtin').buffers()
      end,
    },
    {
      '<leader>tB',
      function()
        util.lazy_require('telescope.builtin').buffers({
          show_all_buffers = true,
        })
      end,
    },
    {
      '<leader>th',
      function()
        util.lazy_require('telescope.builtin').help_tags()
      end,
    },
    {
      '<leader>tc',
      function()
        util.lazy_require('telescope.builtin').commands()
      end,
    },
  },
}
