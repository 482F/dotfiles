-- コメント
local mini_comment = require('mini.comment')
mini_comment.setup({
  options = {
    ignore_blank_line = true,
    pad_comment_parts = false,
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

require('ts_context_commentstring').setup({
  enable_autocmd = false,
  languages = {
    vue = {
      __default = '<!-- %s -->',
      attribute = 'v-comment:%s',
      directive_attribute = 'v-comment:%s',
    },
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
  local mode, lhs, rhs, opts = unpack(key)
  vim.keymap.set(mode, lhs, function()
    require('ts_context_commentstring').update_commentstring()
    return rhs
  end, vim.tbl_extend('force', opts, { expr = true }))
end
