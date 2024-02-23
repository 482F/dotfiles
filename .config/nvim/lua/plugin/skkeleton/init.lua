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
        local tablename = 'azik'

        vim.fn['skkeleton#initialize']()

        require('plugin/skkeleton/kanatable-' .. tablename).register_kanatable()

        local skkpath = vim.fn.stdpath('data') .. util.path_delimiter .. 'skk'

        vim.fn['skkeleton#config']({
          globalDictionaries = { skkpath .. util.path_delimiter .. 'SKK-JISYO.L' },
          eggLikeNewline = true,
          showCandidatesCount = 0,
          selectCandidateKeys = '1234567',
          immediatelyOkuriConvert = true,
          kanaTable = tablename,
          immediatelyDictionaryRW = true,
          userDictionary = os.getenv('HOME') .. '/.skkeleton',
        })

        vim.fn['skkeleton#register_keymap']('henkan', 'X', false)

        vim.keymap.set({ 't', 'i', 'c' }, '<C-l>', '<Plug>(skkeleton-toggle)')
      end,
    })
  end,
}