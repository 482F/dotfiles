local id = 'terminal-' .. math.random(0, 10000000)
local i = 0

local function get_name()
  return id .. '-' .. i
end

local function open()
  local buffers = vim.tbl_filter(function(v)
    return string.find(v.name, id, 1, true) ~= nil
  end, vim.fn.getbufinfo())

  if #buffers <= 0 then
    i = i + 1
    vim.cmd.terminal()
    vim.cmd.file(get_name())
  end

  vim.cmd.edit(get_name())
  vim.bo[vim.fn.bufnr(get_name())].buflisted = false
end

local keys = vim.tbl_map(function(v)
  return {
    '<leader>@' .. v.suffix,
    v.func,
    desc = v.desc,
  }
end, {
  {
    suffix = '@',
    func = open,
    desc = 'ターミナルを開く',
  },
  {
    suffix = 't',
    func = function()
      vim.cmd.tabnew()
      open()
      pcall(vim.cmd.bdelete, '#')
    end,
    desc = 'ターミナルを新しいタブで開く',
  },
})

keys = require('util/stream').inserted_all(keys, { {
  '<C-Space><C-Space>',
  '<C-\\><C-n>',
  mode = 't',
} })

return {
  dir = '',
  name = 'terminal',
  keys = keys,
}
