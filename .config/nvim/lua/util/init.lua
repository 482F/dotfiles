local util = {}

util.map = function(t, func)
  local newArr = {}
  for key, value in pairs(t) do
    newArr[key] = func(value, key)
  end
  return newArr
end

util.is_integer = function(inVal)
  if type(inVal) ~= 'number' then
    return false
  else
    return inVal % 1 .. '' == '0'
  end
end

util.for_each = function(t, func)
  util.map(t, func)
end

util.filter = function(t, func)
  local new_arr = {}
  local i = 1
  for key, value in pairs(t) do
    if func(value, key) then
      local newKey
      if util.is_integer(key) then
        newKey = i
        i = i + 1
      else
        newKey = key
      end
      table.insert(new_arr, newKey, value)
    end
  end
  return new_arr
end

util.reduce = function(t, func, initial)
  local result = initial
  for key, value in pairs(t) do
    result = func(result, value, key)
  end
  return result
end

util.reg_commands = function(commands, group_name)
  if group_name == nil then
    group_name = 'mycommand'
  end
  util.for_each(commands, function(value, name)
    if type(value) ~= 'function' then
      return
    end
    vim.keymap.set('n', '<Plug>(' .. group_name .. '.' .. name .. ')', value)
  end)
  return commands
end

util.from_pairs = function(t)
  local new_table = {}
  for _, value in pairs(t) do
    new_table[value[1]] = value[2]
  end
  return new_table
end

util.pairs = function(t)
  local new_table = {}
  local i = 1
  for key, value in pairs(t) do
    new_table[i] = { key, value }
  end
  return new_table
end

util.merge = function(t1, t2)
  local new_table = {}
  for key, value in pairs(t1) do
    new_table[key] = value
  end
  for key, value in pairs(t2) do
    new_table[key] = value
  end
  return new_table
end

util.stream = function(t)
  local stream = util.from_pairs(util.map({ 'map', 'pairs', 'for_each', 'filter', 'reduce', 'from_pairs', }, function(funcName)
    return { funcName, function(...)
      return util.stream(util[funcName](t, ...))
    end }
  end))

  stream.terminate = function()
    return t
  end
  return stream
end

return util
