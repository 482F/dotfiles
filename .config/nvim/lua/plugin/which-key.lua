local stream = require('util/stream')
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local futil = require('util/func')
    -- which-key を <C-c> でキャンセルできるように
    futil.override(vim.fn, 'getcharstr', function(original, ...)
      local ok, char = pcall(original, ...)
      if not ok then
        if char == 'Keyboard interrupt' then
          require('which-key/util').exit()
        end
        error(char, 0)
      end
      return char
    end)
  end,
  opts = {
    preset = 'modern',
    plugins = {
      registers = false,
    },
  },
}
