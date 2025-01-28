local mini_pairs = require('mini.pairs')
local stream = require('util/stream')

local mappings = stream.inserted_all(mini_pairs.config.mappings, {
  ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
  ['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },
}, 0)

mappings = stream.inserted_all(
  mappings,
  stream.map(mappings, function()
    return { register = { cr = false } }
  end),
  0
)
mini_pairs.setup({
  mappings = mappings,
})
