-- コメント
local mini_comment = require('mini.comment')
mini_comment.setup({
  options = {
    ignore_blank_line = true,
    pad_comment_parts = true,
    start_of_line = false,
    custom_commentstring = function()
      local ft = vim.bo.filetype
      return ({
        json5 = '// %s',
        sql = '-- %s',
        autohotkey = '; %s',
      })[ft]
    end,
  },
  mappings = {
    comment = 'gc',
    comment_line = 'gcc',
    textobject = 'gc',
  },
})

local keys = {
  {
    'x',
    '<C-/>',
    'gc',
    { remap = true },
  },
  {
    'x',
    '<C-_>',
    'gc',
    { remap = true },
  },
  {
    'n',
    '<C-/>',
    'gcc',
    { remap = true },
  },
  {
    'n',
    '<C-_>',
    'gcc',
    { remap = true },
  },
}

for _, key in pairs(keys) do
  vim.keymap.set(unpack(key))
end
