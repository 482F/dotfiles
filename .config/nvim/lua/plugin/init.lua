local stream = require('util/stream')
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

local plugin_names = {
  -- 'possession', -- セッション管理
  'telescope', -- fzf
  'telescope-file-browser', -- ファイラ
  'telescope-ui-select', -- 選択 UI telescope 化
  'telescope-emoji', -- 絵文字 FF
  'flash', -- easymotion
  'mason', -- LSP 管理
  'neodev', -- neovim lua api 等の型情報
  'mason-lspconfig', -- LSP 設定
  'nvim-cmp', -- 補完
  'treesitter', -- treesitter (構文解析)
  'nvim-highlight-colors', -- カラーコードの色表示
  'colorscheme', -- カラースキーマ
  'nvim-dap', -- デバッグ
  'chowcho', -- ウィンドウ移動
  'open-web', -- ブラウザで開く
  'nvim-dbee', -- DB クライアント
  'which-key', -- キーマップ表示
  'translate', -- 翻訳
  'git-conflict', -- git コンフリクト関連
  'skkeleton', -- SKK
  'plenary', -- 汎用関数詰めあわせ

  -- 複数用途
  -- - ステータスライン
  -- - コメントアウト
  -- - 括弧等の操作
  -- - 引数の展開・折りたたみ
  'mini',

  -- 各言語専用プラグイン
  'nvim-jdtls', -- java
  'flutter-tools', -- flutter

  -- 自作プラグイン
  'terminal', -- ターミナル
}

require('lazy').setup(stream.flat_map(plugin_names, function(plugin_name)
  local plugin = require('plugin/' .. plugin_name)
  if
    type(plugin[1]) == 'string'
    or not stream.every(stream.keys(plugin), function(key)
      return type(key) == 'number'
    end)
  then
    return { plugin }
  else
    return plugin
  end
end))

