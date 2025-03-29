return {
  dependencies = {
    'Shougo/ddc-source-lsp',
    'uga-rosa/ddc-source-lsp-setup',
    'matsui54/denops-popup-preview.vim',
    'L3MON4D3/LuaSnip',
  },
  options = {
    sources = { 'lsp' },
    sourceOptions = {
      lsp = {
        mark = 'lsp',
      },
    },
    sourceParams = {
      lsp = {
        enableResolveItem = true,
        enableDisplayDetail = true,
        enableAdditionalTextEdit = true,
      },
    },
  },
  init = function()
    require('ddc_source_lsp_setup').setup({ respect_trigger = false })
    vim.fn['popup_preview#enable']()
    vim.keymap.set('i', '<C-d>', function()
      vim.fn['popup_preview#scroll'](6)
    end)
    vim.keymap.set('i', '<C-u>', function()
      vim.fn['popup_preview#scroll'](-6)
    end)
  end,
}
