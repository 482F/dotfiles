local util = require('util/init')

return {
  'vim-skk/denops-skkeleton.vim',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = { 'DenopsPluginPost:skkeleton' },
      callback = function()
        vim.keymap.set({ 't', 'i', 'c' }, '<C-l>', '<Plug>(skkeleton-toggle)')
        local skkpath = vim.fn.stdpath('data') .. util.path_delimiter .. 'skk'
        vim.fn['skkeleton#config']({
          globalDictionaries = { skkpath .. util.path_delimiter .. 'SKK-JISYO.L' },
        })
      end,
    })
  end,
}
