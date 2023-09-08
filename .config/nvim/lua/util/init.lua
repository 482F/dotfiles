local util = {}

util.is_integer =
  ---@param val unknown
  ---@return boolean
  function(val)
    if type(val) ~= 'number' then
      return false
    else
      return val % 1 .. '' == '0'
    end
  end

util.reg_commands =
  ---@generic C : { [string]: function }
  ---@param commands C
  ---@param group_name string?
  ---@return C
  function(commands, group_name)
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

util.loadrequire =
  ---@param modname string
  function(modname)
    local function requiref()
      return require(modname)
    end
    local success, result = pcall(requiref)
    if not success and not string.find(result, "module '" .. modname .. "' not found", 1, true) then
      error(result)
    end
    return result
  end

local modules = {}
util.lazy_require =
  ---@param modname string
  function(modname)
    if modules[modname] == nil then
      modules[modname] = { require(modname) }
    end
    return modules[modname][1]
  end

util.split =
  ---@param str string
  ---@param separator string
  function(str, separator)
    ---@type string[]
    local strs = {}

    local i = 1
    local sep_len = string.len(separator)
    local str_len = string.len(str)

    ---@type integer?
    local s = 1 - sep_len

    ---@type integer
    local prevS = 1
    while s ~= str_len + 2 do
      prevS = s --[[@as integer]]
      s = string.find(str, separator, s + sep_len, true) or (str_len + 2)
      strs[i] = string.sub(str, prevS + 1, s - 1)
      i = i + 1
    end
    return strs
  end

util.join =
  ---@param strs string[]
  ---@param separator string
  ---@return string
  function(strs, separator)
    local stream = util.lazy_require('util/stream')
    local first = stream.start(strs).slice(1, 2).find(function()
      return true
    end)

    if first == nil then
      return ''
    end
    return stream.reduce(stream.slice(strs, 2), function(all, str)
      return all .. separator .. str
    end, first)
  end

util.json_stringify =
  ---@param json unknown
  ---@param depth integer?
  ---@return string
  function(json, depth)
    depth = depth or 1
    local stream = util.lazy_require('util/stream')
    local json_type = type(json)
    if stream.includes({ 'number', 'boolean' }, json_type) then
      return tostring(json)
    elseif json_type == 'string' then
      return '"' .. json .. '"'
    elseif json == nil then
      return 'null'
    elseif json_type == 'table' then
      local keys = stream.keys(json)
      local is_array = stream.every(keys, function(key)
        return type(key) == 'number'
      end)
      local indent = function(body)
        local pad = string.rep(' ', depth * 2)
        return util.join(
          stream.map(util.split(body, '\n'), function(line)
            return pad .. line
          end),
          '\n'
        )
      end
      if is_array then
        return '[\n'
          .. indent(util.join(
            stream.map(json, function(v)
              return util.json_stringify(v, depth + 1)
            end),
            ',\n'
          ))
          .. '\n]'
      else
        return '{\n'
          .. indent(util.join(
            stream.map(json, function(v, k)
              return k .. ': ' .. util.json_stringify(v, depth + 1)
            end),
            ',\n'
          ))
          .. '\n}'
      end
    else
      return '`type:' .. json_type .. '`'
    end
  end

util.show_in_popup =
  ---@param json unknown
  ---@return table
  function(json)
    local Popup = require('nui.popup')

    local popup = Popup({
      enter = false,
      focusable = true,
      border = {
        style = 'rounded',
      },
      anchor = 'NW',
      position = { row = 1, col = 1 },
      size = {
        width = '80%',
        height = '60%',
      },
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
      callback = function()
        popup:unmount()
      end,
      once = true,
    })

    popup:mount()

    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, util.split(util.json_stringify(json), '\n'))
    return popup
  end

---@type boolean
util.is_gui = vim.fn.has('gui_running') == 1

return util