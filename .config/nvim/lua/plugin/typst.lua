return {
  {
    'kaarmu/typst.vim',
    dependencies = { 'chomosuke/typst-preview.nvim' },
    ft = 'typst',
    keys = {
      { '<leader>lo', ':TypstPreview<CR>' },
    },
    config = function()
      require('lspconfig').tinymist.setup({
        settings = {
          formatterMode = 'typstyle',
          -- exportPdf = 'onType',
          semanticTokens = 'disable',
        },
      })
      require('typst-preview').setup({
        open_cmd = "brave '%s'",
        dependencies_bin = {
          ['tinymist'] = 'tinymist',
          ['websocat'] = 'websocat',
        },
        port = 28941,
      })
    end,
  },
}
