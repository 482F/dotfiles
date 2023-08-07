local util = require('util')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { -- セッション管理
    name = 'possession',
    setup = { 'jedrzejboczar/possession.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  { -- fzf
    name = 'telescope',
    setup = { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  { -- easymotion
    name = 'pounce',
    setup = { 'rlane/pounce.nvim' },
  },
  { -- LSP 管理
    name = 'mason',
    setup = { 'williamboman/mason.nvim' },
  },
  { -- LSP 設定
    name = 'mason-lspconfig',
    setup = {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'neovim/nvim-lspconfig' },
    },
  },
  { -- フォーマッタ管理
    name = 'null-ls',
    setup = {
      'jose-elias-alvarez/null-ls.nvim',
      dependencies = { 'mason-org/mason-registry' },
    },
  },
  { -- 補完
    name = 'nvim-cmp',
    setup = { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/vim-vsnip' } },
  },
  {
    name = 'nvim-jdtls',
    setup = { 'mfussenegger/nvim-jdtls' },
  },
}

local function loadrequire(module)
  local function requiref(module)
    require(module)
  end
  local _, err = pcall(requiref, module)
  if err and not string.find(err, "module '" .. module .. "' not found", 1, true) then
    print(module, err)
    -- error(err)
  end
end

require('lazy').setup(util
  .stream(plugins)
  .map(function(plugin, i)
    return util.merge(plugin.setup, {
      config = function()
        loadrequire('plugin/' .. plugin.name)
      end,
    })
  end)
  .terminate())

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    -- { name = "buffer" },
    -- { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  experimental = {
    ghost_text = true,
  },
})
