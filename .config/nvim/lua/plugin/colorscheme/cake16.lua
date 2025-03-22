return {
  'zefei/cake16',
  config = function()
    vim.cmd.colorscheme('cake16')

    local util = require('util')
    util.set_term_color('brightGreen', '#a2d3a3')
    util.set_term_color('brightRed', '#d1a0a0')
  end,
}
