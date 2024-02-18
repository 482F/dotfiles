local M = {}

math.randomseed(os.time())

---@param min integer
---@param max integer
---@return integer
function M.randint(min, max)
  local r = math.random(min, max + 1)
  return math.floor(r)
end

---@generic T
---@param t T[]
---@return T, integer
function M.pick(t)
  local stream = require('util/stream')
  local r = M.randint(1, stream.length(t) - 1)
  return t[r], r
end

---@generic T
---@param t T[]
---@return T[]
function M.shuffle(t)
  local stream = require('util/stream')
  local cloned_t = stream.slice(t)
  local new_arr = {}
  while 1 <= #cloned_t do
    local v, r = M.pick(cloned_t)
    table.remove(cloned_t, r)
    table.insert(new_arr, v)
  end
  return new_arr
end

return M
