local lspconfig = require('lspconfig')

require('mason-lspconfig').setup({
  handlers = require('util').map({
    lua_ls = require('plugin/lsp/lua'),
    denols = require('plugin/lsp/deno'),
  }, function(func, key)
    return function()
      return func(lspconfig[key], lspconfig)
    end
  end),
})
