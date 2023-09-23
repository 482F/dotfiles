return function(server, lspconfig)
  require('lspconfig').volar.setup({
    filetypes = { 'vue' },
  })
end
