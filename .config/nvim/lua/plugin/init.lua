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

local plugins = {
  -- 'possession', -- セッション管理
  'telescope', -- fzf
  'telescope-file-browser', -- ファイラ
  'telescope-ui-select', -- 選択 UI telescope 化
  'telescope-emoji', -- 絵文字 FF
  'pounce', -- easymotion
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

require('lazy').setup(stream.flat_map(plugins, function(plugin)
  local plugin = require('plugin/' .. plugin)
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

-- 引数無しで起動したときのみ表示したい
-- vim.api.nvim_create_autocmd({ 'User' }, {
--   pattern = { 'VeryLazy' },
--   callback = function()
--     local lazy_view = require('lazy.view')
--     lazy_view.show('profile')
--     local view = lazy_view.view
--     vim.print('press any key to continue...')
--     vim.fn.getchar()
--     view:hide()
--     vim.print('')
--   end,
-- })
