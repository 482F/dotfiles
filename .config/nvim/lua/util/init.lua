local M = {}

---@param val unknown
---@return boolean
function M.is_integer(val)
  if type(val) ~= 'number' then
    return false
  else
    return val % 1 .. '' == '0'
  end
end

---@generic C : { [string]: fun(...: any): any }
---@param commands C
---@param group_name string?
---@return C
function M.reg_commands(commands, group_name)
  if group_name == nil then
    group_name = 'mycommand'
  end
  require('util/stream').for_each(commands, function(value, name)
    if type(value) ~= 'function' then
      return
    end
    vim.keymap.set('n', '<Plug>(' .. group_name .. '.' .. name .. ')', value)
  end)
  return commands
end

---@type boolean
M.is_gui = vim.fn.has('gui_running') == 1

---@param bufnr integer
---@param lnum integer
function M.remove_quickfix_by_bufnr_and_lnum(bufnr, lnum)
  local qflist = vim.fn.getqflist()
  vim.fn.setqflist(require('util/stream').filter(qflist, function(qf)
    return qf.bufnr ~= bufnr or qf.lnum ~= lnum
  end))
end

---@param bufnr integer
function M.get_winnr_by_bufnr(bufnr)
  local winids = vim.fn.win_findbuf(bufnr)
  local tabnr = vim.fn.tabpagenr()
  for _, winid in pairs(winids) do
    if tabnr == vim.api.nvim_win_get_tabpage(winid) then
      local winnr = vim.fn.win_id2win(winid)
      return winnr
    end
  end
end

---@param bufnr integer
function M.focus_by_bufnr(bufnr)
  local winnr = M.get_winnr_by_bufnr(bufnr)
  local winid = vim.fn.win_getid(winnr)
  vim.fn.win_gotoid(winid)
end

---@type boolean
M.is_windows = vim.fn.exists('+shellslash') ~= 0

---@type boolean
M.is_wsl = not M.is_windows and vim.fn.readfile('/proc/version')[1]:find('[mM]icrosoft')

M.open_url = (function()
  if vim.fn.has('windows') then
    ---@param url string
    return function(url)
      vim.notify(vim.inspect(url))
      vim.fn.jobstart({ 'cmd.exe', '/c', 'start', url }, { detach = true })
    end
  end
  return function() end
end)()

---@type string
M.path_delimiter = (function()
  if M.is_windows then
    return '\\'
  else
    return '/'
  end
end)()

---@param write boolean
---@param bang boolean
---@param winclose boolean
---@param bufnr? integer
function M.bd(write, bang, winclose, bufnr)
  bufnr = bufnr or vim.fn.bufnr()

  if write then
    vim.fn.win_execute(vim.fn.bufwinid(bufnr), 'write')
  end

  if winclose then
    vim.cmd.bdelete({ args = { bufnr }, bang = bang })
    return
  end

  local allwinids = vim.fn.win_findbuf(bufnr)
  local runallwin = function(func)
    require('util/stream').for_each(allwinids, function(winid)
      vim.api.nvim_win_call(winid, func)
    end)
  end

  runallwin(function()
    vim.cmd.bprev()
  end)

  local closed, err = pcall(vim.cmd.bdelete, { args = { bufnr }, bang = bang })
  if not closed then
    runallwin(function()
      vim.cmd.bnext()
    end)
    error(err, 0)
  end
end

---@param base string
function M.ancestor_dirs(base)
  local dirs = {}
  local dir = base:gsub('%' .. M.path_delimiter .. '$', '') .. M.path_delimiter
  while dir ~= '' do
    table.insert(dirs, dir)
    dir = dir:gsub('[^%' .. M.path_delimiter .. ']*' .. M.path_delimiter .. '$', '')
  end
  return dirs
end

---@param filename string
function M.file_exists(filename)
  local fu = require('util/func')
  local stat = vim.loop.fs_stat(filename)
  return fu.is_truthy(stat and stat.type) or false
end

---@param mode string | table
---@param lhs string
---@param rhs string | fun(...: any): any
---@param opts? table
function M.set_repeat_keymap(mode, lhs, rhs, opts)
  local without_last_keys = lhs:sub(1, -2)
  local repeat_keys = '<Plug>' .. without_last_keys

  vim.keymap.set(mode, repeat_keys, '<Nop>', opts)

  ---@type string | function
  local repeat_rhs
  if type(rhs) == 'string' then
    repeat_rhs = rhs .. repeat_keys
  elseif type(rhs) == 'function' then
    repeat_rhs = function()
      rhs()
      vim.api.nvim_input(repeat_keys)
    end
  else
    error('rhs is not string or function')
  end

  vim.keymap.set(mode, lhs, repeat_rhs, opts)
  vim.keymap.set(mode, '<Plug>' .. lhs, repeat_rhs, opts)
end

---@param title string
function M.exec_code_action(title)
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.title == title
    end,
    apply = true,
  })
end

return M
