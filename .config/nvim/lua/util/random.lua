local random = {}

math.randomseed(os.time())

---@param min integer
---@param max integer
---@return integer
random.randint = function(min, max)
  local r = math.random(min, max + 1)
  return math.floor(r)
end

---@generic T
---@param t T[]
---@return T, integer
random.pick = function(t)
  local stream = require('util/stream')
  local r = random.randint(1, stream.length(t) - 1)
  return t[r], r
end

---@generic T
---@param t T[]
---@return T[]
random.shuffle = function(t)
  local stream = require('util/stream')
  local cloned_t = stream.slice(t)
  local new_arr = {}
  while 1 <= #cloned_t do
    local v, r = random.pick(cloned_t)
    table.remove(cloned_t, r)
    table.insert(new_arr, v)
  end
  return new_arr
end

return random
