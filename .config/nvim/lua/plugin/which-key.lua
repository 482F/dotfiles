return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      registers = false,
    },
    triggers_blacklist = {
      i = (function()
        local blackchars = {}
        local blackstr = '\'"`(){}[]<>'
        for i = 1, #blackstr, 1 do
          table.insert(blackchars, blackstr:sub(i, i))
        end
        return blackchars
      end)(),
    },
  },
}
