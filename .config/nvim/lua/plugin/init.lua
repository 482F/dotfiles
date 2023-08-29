-- lazy インストール
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  print(lazypath)
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

local util = require('util.init')
local stream = require('util/stream')

local plugins = {
  -- 'possession', -- セッション管理
  'telescope', -- fzf
  'telescope-file-browser', -- ファイラ
  'telescope-ui-select', -- 選択 UI telescope 化
  'pounce', -- easymotion
  'mason', -- LSP 管理
  'mason-lspconfig', -- LSP 設定
  'nvim-cmp', -- 補完
  'treesitter', -- treesitter (構文解析)
  'nvim-highlight-colors', -- カラーコードの色表示
  'colorscheme', -- カラースキーマ
  'nvim-dap', -- デバッグ

  -- 複数用途
  -- - ステータスライン
  -- - コメントアウト
  -- - 括弧等の操作
  -- - 引数の展開・折りたたみ
  'mini',

  -- 各言語専用プラグイン
  'nvim-jdtls', -- java
}

require('lazy').setup(stream
  .start(plugins)
  .map(function(plugin)
    return util.loadrequire('plugin/' .. plugin)
  end)
  .terminate())
