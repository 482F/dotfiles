local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {})
local keys = vim.tbl_map(function(def)
  local desc = def.opt.desc
  if desc ~= nil then
    desc = 'lsp-' .. desc
  end
  return vim.tbl_extend('keep', {
    '<leader>l' .. def.suffix,
    def.func,
    desc = desc,
  }, def.opt)
end, {
  {
    suffix = 'c',
    func = function()
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
    end,
    opt = { desc = '情報と診断を表示' },
  },
  { suffix = 'fm', func = vim.cmd.Format, opt = { silent = true, desc = 'フォーマット' } },
  { suffix = 'h', func = vim.lsp.buf.hover, opt = { desc = '情報を表示' } },
  { suffix = 'H', func = vim.diagnostic.open_float, opt = { desc = '診断を表示' } },
  { suffix = 'r', func = vim.lsp.buf.references, opt = { desc = '参照に移動' } },
  { suffix = 'd', func = vim.lsp.buf.definition, opt = { desc = '宣言に移動' } },
  { suffix = 'D', func = vim.lsp.buf.declaration, opt = { desc = '定義に移動' } },
  { suffix = 'i', func = vim.lsp.buf.implementation, opt = { desc = '実装に移動' } },
  { suffix = 't', func = vim.lsp.buf.type_definition, opt = { desc = '型定義に移動' } },
  { suffix = 'R', func = vim.lsp.buf.rename, opt = { desc = 'リネーム' } },
  { suffix = 'a', func = vim.lsp.buf.code_action, opt = { desc = 'コードアクション' } },
})

local function lspconfig()
  local stream = require('util/stream')
  local lspconfig = require('lspconfig')
  local lsps = {
    { 'deno', 'denols' },
    { 'lua-language-server', 'lua_ls' },
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
    handlers = stream
      .start(lsps)
      .map(function(v)
        return v[2]
      end)
      .map(function(name)
        return { name, require('plugin/lsp/' .. name) }
      end)
      .from_pairs()
      .map(function(func, key)
        return function()
          return func(lspconfig[key], lspconfig)
        end
      end)
      .terminate(),
  })
  vim.cmd.LspStart()
end

local function formatter()
  local lspconfig = require('lspconfig')
  local stream = require('util/stream')
  local filetypes = {}
  filetypes = stream.from_pairs(stream.flat_map({
    {
      filetypes = { 'lua' },
      data = { require('formatter/filetypes/lua').stylua },
    },
    {
      filetypes = {
        'javascript',
        'typescript',
        'json',
        'jsonc',
        'json5',
        'vue',
        'jsx',
        'tsx',
        'css',
        'scss',
        'markdown',
        'html',
      },
      data = {
        function(...)
          local is_deno = lspconfig.util.root_pattern('deno.jsonc', 'deno.json')(vim.api.nvim_buf_get_name(0)) ~= nil
          if is_deno then
            return require('formatter/defaults/denofmt')(...)
          else
            return require('formatter/defaults/prettierd')(...)
          end
        end,
      },
    },
    {
      filetypes = { '*' },
      data = {
        function()
          local filetype = vim.opt.filetype._value
          if filetypes[filetype] ~= nil then
            return
          end
          vim.lsp.buf.format(nil, 10000000)
        end,
      },
    },
  }, function(v)
    return stream.map(v.filetypes, function(filetype)
      return { filetype, v.data }
    end)
  end))

  require('formatter').setup({
    filetype = filetypes,
  })
end

return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mason-org/mason-registry',
    'rcarriga/nvim-notify',
    'mhartington/formatter.nvim',
  },
  event = 'VeryLazy',
  keys = keys,
  config = function()
    lspconfig()
    formatter()
  end,
}
