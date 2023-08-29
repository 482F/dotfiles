local util = require('util/init')

return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>tf',
      function()
        util.lazy_require('telescope').extensions.file_browser.file_browser()
      end,
    },
  },
  config = function()
    local telescope = util.lazy_require('telescope')
    telescope.setup({
      extensions = {
        file_browser = {
          path = vim.fn.expand('%:p:h'),
          grouped = true,
          hide_parent_dir = true,
          hidden = true,
          hijack_netrw = true,
          mappings = {
            ['i'] = {
              ['<bs>'] = false,
            },
            ['n'] = {},
          },
        },
      },
    })
    telescope.load_extension('file_browser')
  end,
}
