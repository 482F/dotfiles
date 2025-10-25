return {
  'echasnovski/mini.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  event = 'VeryLazy',
  config = function()
    local modnames = {
      'statusline',
      'comment',
      'surround',
      'splitjoin',
      'pairs',
      'notify',
    }

    for _, modname in pairs(modnames) do
      require('plugin/mini/' .. modname)
    end
  end,
}
