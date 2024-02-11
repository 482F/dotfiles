local util = require('util/init')

return {
  'vim-skk/denops-skkeleton.vim',
  dependencies = {
    'vim-denops/denops.vim',
    'NI57721/skkeleton-state-popup',
  },
  config = function()
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = { 'DenopsPluginPost:skkeleton' },
      callback = function()
        local tablename = 'azik'

        vim.keymap.set({ 't', 'i', 'c' }, '<C-l>', '<Plug>(skkeleton-toggle)')

        vim.fn['skkeleton#initialize']()

        require('plugin/skkeleton/kanatable-' .. tablename).register_kanatable()

        local skkpath = vim.fn.stdpath('data') .. util.path_delimiter .. 'skk'

        vim.fn['skkeleton#config']({
          globalDictionaries = { skkpath .. util.path_delimiter .. 'SKK-JISYO.L' },
          eggLikeNewline = true,
          showCandidatesCount = 0,
          selectCandidateKeys = '1234567',
          immediatelyOkuriConvert = true,
          markerHenkan = '',
          markerHenkanSelect = '',
          kanaTable = tablename,
        })

        vim.fn['skkeleton#register_keymap']('henkan', 'X', false)

        vim.fn['skkeleton_state_popup#config']({
          labels = {
            ['input'] = { hira = 'あ', kata = 'ア', hankata = 'ｶﾅ', zenkaku = 'Ａ' },
            ['input:okurinasi'] = { hira = '▽▽', kata = '▽▽', hankata = '▽▽', abbrev = 'ab' },
            ['input:okuriari'] = { hira = '▽▽', kata = '▽▽', hankata = '▽▽' },
            ['henkan'] = { hira = '▼▼', kata = '▼▼', hankata = '▼▼', abbrev = 'ab' },
            ['latin'] = ' A',
          },
          opts = { relative = 'cursor', col = 0, row = 1, anchor = 'NW', style = 'minimal' },
        })
        vim.fn['skkeleton_state_popup#enable']()
      end,
    })
  end,
}
