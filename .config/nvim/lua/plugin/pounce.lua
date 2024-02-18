local keys = {
  {
    't',
    function()
      require('pounce').pounce()
    end,
  },
  {
    'T',
    function()
      require('pounce').pounce({ do_repeat = true })
    end,
    mode = 'n',
  },
  {
    't',
    function()
      require('pounce').pounce({})
    end,
    mode = 'x',
  },
  {
    't',
    function()
      require('pounce').pounce({})
    end,
    mode = 'o',
  },
}

return {
  'rlane/pounce.nvim',
  keys = keys,
}
