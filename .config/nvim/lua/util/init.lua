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
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd.write()
    end)
  end

  if winclose then
    vim.cmd.bdelete({ args = { bufnr }, bang = bang })
    return
  end

  local stream = require('util/stream')

  local allwinids = vim.fn.win_findbuf(bufnr)
  ---@param func fun(winid: number): nil
  local function runallwin(func)
    stream.for_each(allwinids, function(winid)
      vim.api.nvim_win_call(winid, function()
        func(winid)
      end)
    end)
  end

  local views = {}

  runallwin(function(winid)
    views[winid] = vim.fn.winsaveview()

    local winnr = vim.api.nvim_win_get_number(winid)
    local all_jumps, last_jump = unpack(vim.fn.getjumplist(winnr))

    local jumps = stream
      .start(all_jumps)
      .sorted(function(a, b)
        -- bd 実行地点より前は順番に、実行地点より後は逆順にソートする
        -- これにより jumplist の未来方向に bd されていないバッファがあればそこに、
        -- 無ければ過去方向にジャンプすることになる
        local diff = a.key - b.key
        if last_jump < a.key and last_jump < b.key then
          diff = -1 * diff
        end
        return diff
      end)
      .filter(function(j)
        return j.bufnr ~= bufnr and vim.fn.buflisted(j.bufnr) == 1
      end)
      .terminate()
    local jump = jumps[#jumps]
    if jump == nil then
      vim.cmd.bprev()
      return
    end
    vim.api.nvim_win_set_buf(winid, jump.bufnr)
    vim.fn.winrestview(stream.inserted_all(jump, {
      curswant = jump.col,
    }))
  end)

  local closed, err = pcall(vim.cmd.bdelete, { args = { bufnr }, bang = bang })
  if not closed then
    runallwin(function(winid)
      vim.api.nvim_win_set_buf(winid, bufnr)
      vim.fn.winrestview(views[winid])
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

---@param targets string[]
---@param base? string
function M.find_ancestors(targets, base)
  base = base or '.'
  local stream = require('util/stream')
  local dirs = stream.map(
    vim.fs.find(targets, {
      upward = true,
      path = base,
    }),
    function(path)
      return vim.fs.dirname(path)
    end
  )
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

  ---@type string | function
  local repeat_rhs
  local expr = opts ~= nil and opts.expr
  if type(rhs) == 'string' then
    repeat_rhs = rhs .. repeat_keys
  elseif type(rhs) == 'function' then
    if not expr then
      local _rhs = rhs
      rhs = function()
        _rhs()
      end
    end

    expr = true
    repeat_rhs = function()
      local result = rhs()
      if type(result) ~= 'string' then
        result = ''
      end
      return result .. repeat_keys
    end
  else
    error('rhs is not string or function')
  end

  local new_opts = require('util/stream').inserted_all(opts or {}, { expr = expr })

  vim.keymap.set(mode, lhs, repeat_rhs, new_opts)
  vim.keymap.set(mode, '<Plug>' .. lhs, repeat_rhs, new_opts)

  vim.keymap.set(mode, repeat_keys, '<Nop>')
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

---@param name string
---@param command string | function
---@param opts any
function M.create_command_and_abbrev(name, command, opts)
  local uppered = name:sub(1, 1):upper() .. name:sub(2)

  vim.api.nvim_create_user_command(uppered, command, opts or {})
  -- TODO: function とか使えるなら使いたい。abbrev は lua function を使えなさそうなので、imap とかで代用する？
  vim.cmd(
    string.format(
      'cabbrev <expr> %s (getcmdtype() ==# ":" && getcmdline() ==# "%s" ? "%s" : "%s")',
      name,
      name,
      uppered,
      name
    )
  )
end

local color_map = {
  black = 0,
  red = 1,
  green = 2,
  yellow = 3,
  blue = 4,
  purple = 5,
  cyan = 6,
  white = 7,
  brightBlack = 8,
  brightRed = 9,
  brightGreen = 10,
  brightYellow = 11,
  brightBlue = 12,
  brightPurple = 13,
  brightCyan = 14,
  brightWhite = 15,
}
---@return { [string]: string }
function M.get_term_colors()
  local stream = require('util/stream')
  return stream.map(color_map, function(n)
    return vim.g['terminal_color_' .. n]
  end)
end

---@param name string
---@param color string
function M.set_term_color(name, color)
  vim.g['terminal_color_' .. color_map[name]] = color
end

---@param color string | number ##abcdef | 11259375
---@param multipliers number | { r: number, g: number, b: number }
function M.mult_color(color, multipliers)
  local hex_color = color
  if type(color) == 'number' then
    hex_color = '#' .. ('000000' .. string.format('%x', color)):sub(-6)
  end
  if type(multipliers) == 'number' then
    multipliers = { r = multipliers, g = multipliers, b = multipliers }
  end
  local stream = require('util/stream')

  local mcols = stream.map({ r = 2, g = 4, b = 6 }, function(start, key)
    local hex = hex_color:sub(start, start + 1)
    local dec = tonumber(hex, 16)
    local mdec = math.min(255, math.floor(0.5 + dec * (multipliers[key] == nil and 1 or multipliers[key])))
    local mhex = ('0' .. string.format('%x', mdec)):sub(-2)
    return mhex
  end)

  return '#' .. mcols.r .. mcols.g .. mcols.b
end

---@param opt
---@param values any[]
---@param state? boolean
function M.toggle_opts(opt, values, state)
  if #values <= 0 then
    return state
  end

  local stream = require('util/stream')
  state = state or not stream.includes(opt:get(), values[1])

  local fn
  if state then
    fn = opt.append
  else
    fn = opt.remove
  end

  vim.fn.foreach(values, function(_, value)
    fn(opt, value)
  end)

  return state
end

return M
