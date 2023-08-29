local util = require('util/init')

local keys = {
  {
    't',
    function()
      util.lazy_require('pounce').pounce()
    end,
  },
  {
    'T',
    function()
      util.lazy_require('pounce').pounce({ do_repeat = true })
    end,
    mode = 'n',
  },
  {
    't',
    function()
      util.lazy_require('pounce').pounce({})
    end,
    mode = 'x',
  },
  {
    't',
    function()
      util.lazy_require('pounce').pounce({})
    end,
    mode = 'o',
  },
}

return {
  'rlane/pounce.nvim',
  keys = keys,
}
