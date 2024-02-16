local util = require('util/init')

local intermediates = {}
local terminals = {}

---@generic K
---@generic V
---@param t { [K]: V }
---@generic R
---@param func fun(value: V, key: K): R
---@return { [K]: R }
function intermediates.map(t, func)
  local new_arr = {}
  for key, value in pairs(t) do
    new_arr[key] = func(value, key)
  end
  return new_arr
end

---@generic V
---@param t V[]
---@generic R
---@param func fun(value: V, key: integer): R[]
---@return R[]
function intermediates.flat_map(t, func)
  local new_arr = {}
  local new_arr_i = 1
  for loop_i, value in pairs(t) do
    for _, result in pairs(func(value, loop_i)) do
      new_arr[new_arr_i] = result
      new_arr_i = new_arr_i + 1
    end
  end
  return new_arr
end

---@generic K
---@generic V
---@param t { [K]: V }
---@generic R
---@param func fun(value: V, key: K): boolean
---@return { [K]: V? }
function intermediates.filter(t, func)
  local new_arr = {}
  local i = 1
  for key, value in pairs(t) do
    if func(value, key) then
      local new_key
      if util.is_integer(key) then
        new_key = i
        i = i + 1
      else
        new_key = key
      end
      table.insert(new_arr, new_key, value)
    end
  end
  return new_arr
end

---@generic K
---@generic V
---@param t { [1]: K, [2]: V }[]
---@return { [K]: V }
function intermediates.from_pairs(t)
  local new_table = {}
  for _, value in pairs(t) do
    new_table[value[1]] = value[2]
  end
  return new_table
end

---@generic K
---@generic V
---@param t { [K]: V }
---@return { [1]: K, [2]: V }[]
function intermediates.pairs(t)
  local new_table = {}
  local i = 1
  for key, value in pairs(t) do
    new_table[i] = { key, value }
    i = i + 1
  end
  return new_table
end

---@generic K1
---@generic V1
---@generic K2
---@generic V2
---@param t1 { [K1]: V1 }
---@param t2 { [K2]: V2 }
---@return { [K1]: V1, [K2]: V2 }
function intermediates.merge(t1, t2)
  local new_table = {}
  for key, value in pairs(t1) do
    new_table[key] = value
  end
  for key, value in pairs(t2) do
    new_table[key] = value
  end
  return new_table
end

---@generic K
---@param t { [K]: any }
---@return K[]
function intermediates.keys(t)
  return intermediates.map(intermediates.pairs(t), function(pair)
    return pair[1]
  end)
end

---@generic V
---@param t { [any]: V }
---@return V[]
function intermediates.values(t)
  return intermediates.map(intermediates.pairs(t), function(pair)
    return pair[2]
  end)
end

---@generic T
---@param t T[]
---@param s number?
---@param e number?
---@return T[]
function intermediates.slice(t, s, e)
  local len = terminals.length(t)
  local new_table = {}
  s = (s == nil) and 1 or s

  if e == nil or len < e then
    e = len + 1
  elseif e < 0 then
    e = len + 1 + e
  end

  local loop_i = 1
  local key_i = 1
  for key, value in pairs(t) do
    if e <= loop_i then
      return new_table
    end
    if s <= loop_i then
      if type(key) == 'number' then
        new_table[key_i] = t[key]
        key_i = key_i + 1
      else
        new_table[key] = t[key]
      end
    end
    loop_i = loop_i + 1
  end
  return new_table
end

---@generic T
---@param t T[]
---@param n T[]
---@return T[]
function intermediates.inserted_all(t, n)
  local new_arr = intermediates.slice(t)
  terminals.for_each(n, function(v)
    table.insert(new_arr, v)
  end)
  return new_arr
end

---@generic K
---@generic V
---@param t { [K]: V }
---@param func fun(value: V, key: K): unknown?
---@return nil
function terminals.for_each(t, func)
  intermediates.map(t, func)
end

---@generic K
---@generic V
---@param t { [K]: V }
---@generic R
---@param initial R
---@param func fun(result: R, value: V, key: K): R
---@return R
function terminals.reduce(t, func, initial)
  local result = initial
  for key, value in pairs(t) do
    result = func(result, value, key)
  end
  return result
end

---@generic V
---@param t { [any]: V }
---@param v V
---@return boolean
function terminals.includes(t, v)
  for key, value in pairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

---@generic K
---@generic V
---@param t { [K]: V }
---@param func fun(v: V, k: K): boolean
---@return V?
function terminals.find(t, func)
  for key, value in pairs(t) do
    if func(value, key) then
      return value
    end
  end
  return nil
end

---@generic K
---@generic V
---@param t { [K]: V }
---@param func fun(v: V, k: K): boolean
---@return boolean
function terminals.some(t, func)
  return terminals.find(t, func) ~= nil
end

---@generic K
---@generic V
---@param t { [K]: V }
---@param func fun(v: V, k: K): boolean
---@return boolean
function terminals.every(t, func)
  return not terminals.some(t, function(v, k)
    return not func(v, k)
  end)
end

---@param t { [any]: any }
---@return number
function terminals.length(t)
  local i = 0
  for _, _ in pairs(t) do
    i = i + 1
  end
  return i
end

---@alias intermediate_names 'map' | 'flat_map' | 'pairs' | 'filter' | 'from_pairs' | 'merge' | 'keys' | 'values' | 'slice' | 'inserted_all'
---@alias terminal_names 'for_each' | 'reduce' | 'includes' | 'find' | 'some' | 'every' | 'length' | 'terminate'
---@alias streamed { [intermediate_names]: fun(...: any): streamed; [terminal_names]: fun(...: any): any }
local start
---@type fun(t: table): streamed
start = function(t)
  local s = {}
  s = intermediates.merge(
    s,
    intermediates.map(intermediates, function(func)
      return function(...)
        return start(func(t, ...))
      end
    end)
  )

  s = intermediates.merge(
    s,
    intermediates.map(terminals, function(func)
      return function(...)
        return func(t, ...)
      end
    end)
  )
  s.terminate = function()
    return t
  end
  return s
end

return {
  start = start,

  map = intermediates.map,
  flat_map = intermediates.flat_map,
  pairs = intermediates.pairs,
  filter = intermediates.filter,
  from_pairs = intermediates.from_pairs,
  merge = intermediates.merge,
  keys = intermediates.keys,
  values = intermediates.values,
  slice = intermediates.slice,
  inserted_all = intermediates.inserted_all,

  for_each = terminals.for_each,
  reduce = terminals.reduce,
  includes = terminals.includes,
  find = terminals.find,
  some = terminals.some,
  every = terminals.every,
  length = terminals.length,
}
