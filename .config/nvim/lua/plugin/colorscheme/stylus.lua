return {
  'nickburlett/vim-colors-stylus',
  config = function()
    vim.cmd.colorscheme('stylus')
    vim.cmd.highlight('Pmenu', 'guibg=#F1F1F1')

    local util = require('util')
    util.set_term_color('brightGreen', '#80d780')
    util.set_term_color('brightRed', '#f78080')
  end,
}
