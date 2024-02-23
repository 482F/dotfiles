local util = require('util')

return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>tf',
      function()
        require('telescope').extensions.file_browser.file_browser({ path = vim.fn.expand('%:p:h') })
      end,
      desc = 'ファイルブラウザ',
    },
  },
  config = function()
    local telescope = require('telescope')
    local fb_actions = require('telescope._extensions.file_browser.actions')
    telescope.setup({
      extensions = {
        file_browser = {
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
