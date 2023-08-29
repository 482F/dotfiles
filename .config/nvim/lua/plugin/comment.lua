local keys = {
  {
    '<C-/>',
    '<Plug>(comment_toggle_linewise_current)',
    mode = 'n',
  },
  {
    '<C-_>',
    '<Plug>(comment_toggle_linewise_current)',
    mode = 'n',
  },
  {
    '<C-/>',
    '<Plug>(comment_toggle_linewise_visual)',
    mode = 'x',
  },
  {
    '<C-_>',
    '<Plug>(comment_toggle_linewise_visual)',
    mode = 'x',
  },
}

return {
  'numToStr/Comment.nvim',
  keys = {
    'gc',
    'gb',
    'gcO',
    'gco',
    'gcA',
    { 'gc', mode = 'x' },
    { 'gb', mode = 'x' },
    unpack(keys),
  },
  opts = {
    opleader = { line = 'gc', block = 'gb' },
    extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
  },
  config = function()
    require('Comment').setup({})
  end,
}
