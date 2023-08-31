return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mason-org/mason-registry',
    'jose-elias-alvarez/null-ls.nvim',
    'MunifTanjim/nui.nvim',
  },
  event = 'VeryLazy',
  config = function()
    local stream = require('util/stream')

    -- vim.diagnostic.config({ float = { border = 'single' } })

    local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {
      -- border = 'single',
    })

    vim.keymap.set('n', '<leader>lc', function()
      vim.lsp.handlers['textDocument/hover'] = function(...)
        local h_bufnr, h_winid = hover_handler(...)
        vim.lsp.handlers['textDocument/hover'] = hover_handler

        local height
        if h_winid == nil then
          height = 0
        else
          height = vim.api.nvim_win_get_height(h_winid)
        end
        vim.api.nvim_buf_set_var(0, 'lsp_floating_preview', nil)
        local _, d_winnr = vim.diagnostic.open_float()
        if d_winnr == nil then
          return h_bufnr, h_winid
        end
        vim.api.nvim_win_set_config(d_winnr, {
          relative = 'cursor',
          row = height + 1,
          col = 0,
        })

        return h_bufnr, h_winid
      end
      vim.lsp.buf.hover()
    end)
    vim.keymap.set('n', '<leader>lfm', function()
      vim.lsp.buf.format(nil, 5000)
    end)
    vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover)
    vim.keymap.set('n', '<leader>lH', vim.diagnostic.open_float)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references)
    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition)
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition)
    vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)

    local lspconfig = require('lspconfig')

    local lsps = {
      { 'deno', 'denols' },
      { 'lua-language-server', 'lua_ls' },
      { 'prettierd' },
      { 'stylua' },
      { 'typescript-language-server', 'tsserver' },
    }

    local need_to_install_lsps = vim.tbl_filter(
      function(v)
        return not require('mason-registry').is_installed(v)
      end,
      vim.tbl_map(function(v)
        return v[1]
      end, lsps)
    )

    if not vim.tbl_isempty(need_to_install_lsps) then
      require('mason/api/command').MasonInstall(need_to_install_lsps)
    end

    require('mason-lspconfig').setup({
      handlers = stream.map({
        lua_ls = require('plugin/lsp/lua'),
        denols = require('plugin/lsp/deno'),
        tsserver = require('plugin/lsp/tsserver'),
      }, function(func, key)
        return function()
          return func(lspconfig[key], lspconfig)
        end
      end),
    })

    local mason_package = require('mason-core.package')
    local mason_registry = require('mason-registry')
    local null_ls = require('null-ls')

    null_ls.setup({
      sources = stream
        .start(mason_registry.get_installed_packages())
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
}
