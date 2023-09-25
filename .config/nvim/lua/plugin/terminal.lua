local id = 'terminal-' .. math.random(0, 10000000)
local last_i = 0

local function get_terminal_buffers()
  return vim.tbl_filter(function(v)
    return string.find(v.name, id, 1, true) ~= nil
  end, vim.fn.getbufinfo())
end

local function open(index, force_new)
  force_new = force_new or false

  local buffers = get_terminal_buffers()

  if index == nil then
    index = #buffers
  end

  if force_new or (#buffers <= 0) then
    last_i = last_i + 1
    index = #buffers + 1
    vim.cmd.terminal()
    vim.cmd.file(id .. '-' .. last_i)
    buffers = get_terminal_buffers()
  else
    vim.cmd.edit(buffers[index].name)
  end

  vim.bo[buffers[index].bufnr].buflisted = false
end

local function move(delta)
  local buffers = get_terminal_buffers()
  local current_bufnr = vim.fn.bufnr()
  local current_index = 1
  for j, buffer in pairs(buffers) do
    if buffer.bufnr == current_bufnr then
      current_index = j
      break
    end
  end

  open((current_index + delta - 1) % #buffers + 1)
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
    suffix = '`',
    func = function()
      open(nil, true)
    end,
    desc = '新しいターミナルを開く',
  },
  {
    suffix = 't',
    func = function()
      vim.cmd.tabnew('%')
      open()
    end,
    desc = 'ターミナルを新しいタブで開く',
  },
  {
    suffix = '"',
    func = function()
      vim.cmd.new({ args = { '%' }, mods = { split = 'belowright' } })
      open()
    end,
    desc = 'ターミナルを水平に分割して開く',
  },
  {
    suffix = '%',
    func = function()
      vim.cmd.vnew({ args = { '%' }, mods = { split = 'belowright' } })
      open()
    end,
    desc = 'ターミナルを垂直に分割して開く',
  },
  {
    suffix = 'k',
    func = function()
      move(-1)
    end,
    desc = '前のターミナルを開く',
  },
  {
    suffix = 'j',
    func = function()
      move(1)
    end,
    desc = '次のターミナルを開く',
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
