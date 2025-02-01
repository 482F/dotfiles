local stream = require('util/stream')
local util = require('util')

local id = 'terminal-' .. math.random(0, 10000000)
local last_i = 0

local function get_terminal_buffers()
  return stream.filter(vim.fn.getbufinfo(), function(v)
    return string.find(v.name, id, 1, true) ~= nil
  end)
end

local function open(index, force_new, dir)
  force_new = force_new or false

  local buffers = get_terminal_buffers()

  if index == nil then
    index = #buffers
  end

  if force_new or (#buffers <= 0) then
    last_i = last_i + 1
    index = #buffers + 1

    local original_dir = vim.fn.getcwd()
    vim.api.nvim_set_current_dir(dir or original_dir)
    if vim.fn.has('windows') and not util.is_wsl then
      vim.cmd.terminal('set WSLENV=FROM_WIN/u&set FROM_WIN=true&wsl.exe')
    else
      vim.cmd.terminal()
    end
    vim.api.nvim_set_current_dir(original_dir)

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

local keys = stream.map({
  {
    suffix = '@',
    func = open,
    desc = 'ターミナルを開く',
  },
  {
    suffix = 'b@',
    func = function()
      open(nil, false, vim.fn.expand('%:p:h'))
    end,
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
    suffix = 'b`',
    func = function()
      open(nil, true, vim.fn.expand('%:p:h'))
    end,
    desc = 'バッファディレクトリで新しいターミナルを開く',
  },
  {
    suffix = 't',
    func = function()
      vim.cmd.tabnew()
      util.bd(false, false, false)
      open()
    end,
    desc = 'ターミナルを新しいタブで開く',
  },
  {
    suffix = 'bt',
    func = function()
      vim.cmd.tabnew()
      util.bd(false, false, false)
      open(nil, false, vim.fn.expand('%:p:h'))
    end,
    desc = 'ターミナルを新しいタブで開く',
  },
  {
    suffix = '"',
    func = function()
      vim.cmd.new({ mods = { split = 'belowright' } })
      util.bd(false, false, false)
      open()
    end,
    desc = 'ターミナルを水平に分割して開く',
  },
  {
    suffix = '%',
    func = function()
      vim.cmd.vnew({ mods = { split = 'belowright' } })
      util.bd(false, false, false)
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
  {
    suffix = 'p',
    func = function()
      if vim.bo.buftype ~= 'terminal' then
        return
      end

      local body = vim.fn.getreg('*')
      vim.api.nvim_chan_send(vim.bo.channel, body:gsub('[\n\r]$', '') .. '\n')
    end,
    desc = 'コマンドを貼り付けて実行',
  },
}, function(v)
  return {
    '<leader>@' .. v.suffix,
    v.func,
    desc = v.desc,
  }
end)

keys = stream.inserted_all(keys, {
  {
    '<C-[><C-[>',
    '<C-\\><C-n>',
    mode = 't',
  },
  {
    '<C-@><C-@>',
    '<C-\\><C-n>',
    mode = 't',
  },
  {
    '@@<C-[>',
    '<C-\\><C-n>',
    mode = 't',
  },
  {
    '<C-Space><C-Space>',
    '<C-\\><C-n>',
    mode = 't',
  },
})

return {
  dir = '.',
  name = 'terminal',
  keys = keys,
}
