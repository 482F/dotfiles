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

return M
