local M = {}

---@generic T
---@param v T
---@return T
function M.identity(v)
  return v
end

---@param v any
---@return boolean
function M.is_truthy(v)
  if v then
    return true
  else
    return false
  end
end

---@param ... any
---@return fun(t: table<any, any>): any
function M.picker(...)
  local stream = require('util/stream')
  local keys = { ... }
  return function(t)
    return stream.reduce(keys, function(val, key)
      return val[key]
    end, t)
  end
end

---@param f fun(...: any): any
---@return fun(...: any): boolean
function M.negate(f)
  return function(...)
    return not f(...)
  end
end

---@param f (fun(self: (fun(...: any): any), ...: any): any)
---@return (fun(...: any): any)
function M.recursivize(f)
  local rf
  rf = function(...)
    return f(rf, ...)
  end
  return rf
end

---@generic K: any
---@param m table<K, any>
---@param key K
---@param newfunc fun(original: (fun(...: any): any), ...: any): any
function M.override(m, key, newfunc)
  local original = m[key]
  m[key] = function(...)
    return newfunc(original, ...)
  end
end

---@param func fun(...: any): any
---@return fun(...: any): any
function M.once(func)
  local _func
  _func = function(...)
    _func = function() end
    func(...)
  end
  return function(...)
    _func(...)
  end
end

return M
