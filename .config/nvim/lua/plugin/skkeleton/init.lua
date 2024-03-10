local util = require('util')

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
          userDictionary = vim.fn.stdpath('data') .. '/.skkeleton',
        })

        vim.fn['skkeleton#register_keymap']('henkan', 'X', false)
        vim.fn['skkeleton#register_keymap']('henkan', '@', 'henkanForward')
        vim.fn['skkeleton#register_keymap']('henkan', '`', 'henkanBackward')

        vim.keymap.set({ 't', 'i', 'c' }, '<C-l>', '<Plug>(skkeleton-toggle)')

        vim.keymap.set({ 'n' }, '<C-l><C-f>', function()
          vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
            pattern = { '*' },
            once = true,
            callback = function()
              vim.fn['skkeleton#handle']('enable', {})
            end,
          })
          local succeeded, char = pcall(vim.fn.input, 'input target char: ') -- TODO: 一文字目だけ取り出したい
          if not succeeded then
            return
          end
          vim.fn.feedkeys('f' .. char)
        end)

        vim.keymap.set({ 'n' }, '<C-l><C-t>', function()
          vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
            pattern = { '*' },
            once = true,
            callback = function()
              vim.fn['skkeleton#handle']('enable', {})
            end,
          })
          local succeeded, pattern = pcall(vim.fn.input, 'input target pattern: ')
          if not succeeded then
            return
          end

          require('pounce').pounce({ input = pattern })
        end)

        vim.notify('skkeleton loaded')
      end,
    })
  end,
}
