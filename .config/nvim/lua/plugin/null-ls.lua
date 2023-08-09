local mason_package = require('mason-core.package')
local mason_registry = require('mason-registry')
local null_ls = require('null-ls')
local util = require('util')

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    null_ls.setup({
      sources = util
          .stream(mason_registry.get_installed_packages())
          .map(function(package)
            local package_categories = package.spec.categories[1]
            if package_categories == mason_package.Cat.Formatter then
              return null_ls.builtins.formatting[package.name]
            elseif package_categories == mason_package.Cat.Linter then
              return null_ls.builtins.diagnostics[package.name]
            end
          end)
          .filter(function(val)
            return val ~= nil
          end)
          .terminate(),
    })
  end,
})
