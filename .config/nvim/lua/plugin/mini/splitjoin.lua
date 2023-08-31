-- 引数の展開・折りたたみ
local mini_splitjoin = require('mini.splitjoin')
mini_splitjoin.setup({
  mappings = {
    toggle = 'gS',
    split = '',
    join = '',
  },

  detect = {
    brackets = nil,
    separator = ',',
    exclude_regions = nil,
  },
})
