local id = 'terminal-' .. math.random(0, 10000000)
local i = 0

local function open()
  local buffers = vim.tbl_filter(function(v)
    return string.find(v.name, id, 1, true) ~= nil
  end, vim.fn.getbufinfo())

  if #buffers <= 0 then
    vim.cmd.terminal()
    vim.cmd.file(id .. '-' .. i)
    i = i + 1
    return
  end

  local name
  if #buffers == 1 then
    name = buffers[1].name
  else
    return -- TODO: 複数個ターミナルがある時の挙動
  end

  vim.cmd.edit(name)
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
