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
    local fb_actions = require('telescope._extensions.file_browser.actions')
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
              ['<M-->'] = fb_actions.goto_parent_dir,
            },
            ['n'] = {
              ['<bs>'] = fb_actions.goto_parent_dir,
              ['-'] = fb_actions.goto_parent_dir,
            },
          },
        },
      },
    })
    telescope.load_extension('file_browser')
  end,
}
