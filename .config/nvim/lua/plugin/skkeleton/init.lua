return {
  'vim-skk/denops-skkeleton.vim',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    local util = require('util')
    local stream = require('util/stream')

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
        vim.fn['skkeleton#register_keymap']('henkan', ' ', false)

        -- nIME.ahk によるリマップ
        vim.g['skkeleton#mapped_keys'] = stream.inserted_all(
          vim.g['skkeleton#mapped_keys'],
          { '<F1>', '<F2>', '<F3>', '<F4>', '<F5>', '<F6>', '<F7>', '<F8>' }
        )
        vim.fn['skkeleton#register_keymap']('henkan', '<F1>', 'disable') -- CapsLock
        vim.fn['skkeleton#register_keymap']('input', '<F1>', 'disable') -- CapsLock
        vim.fn['skkeleton#register_keymap']('input', '<F3>', 'henkanFirst') -- 変換
        vim.fn['skkeleton#register_keymap']('henkan', '<F3>', 'henkanForward') -- 変換
        vim.fn['skkeleton#register_keymap']('henkan', '<F7>', 'henkanBackward') -- Shift + 変換
        vim.fn['skkeleton#register_keymap']('input', '<F7>', 'katakana') -- Shift + 変換
        vim.fn['skkeleton#register_keymap']('input', '<F4>', 'cancel') -- かな
        vim.fn['skkeleton#register_keymap']('henkan', '<F4>', 'cancel') -- かな
        -- vim.fn['skkeleton#register_keymap']('henkan', '<F2>', '') -- 無変換
        -- vim.fn['skkeleton#register_keymap']('henkan', '<F5>', '') -- Shift + CapsLock
        -- vim.fn['skkeleton#register_keymap']('henkan', '<F6>', '') -- Shift + 無変換
        -- vim.fn['skkeleton#register_keymap']('henkan', '<F8>', '') -- Shift + かな

        vim.keymap.set({ 't', 'i', 'c' }, '<F1>', '<Plug>(skkeleton-toggle)') -- CapsLock

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
