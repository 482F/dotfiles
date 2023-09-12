require('dir-config')
require('misc')
require('option')
require('keymap')
require('command')
require('plugin')

--[[

ウィンドウ移動をもっと簡単に
lua source 改善
- 実行時に自動的に vim.notify(vim.inspect(
- .lua ファイル以外でも lua 読み込み
qflist 複数作れない？
スニペットエンジン？
- cmp の confirm で必要そう
プラグイン
- renerocksai/telekasten.nvim
- kristijanhusak/line-notes.nvim
- akinsho/git-conflict.nvim
- nvim-telescope/telescope-dap.nvim
- Vigemus/iron.nvim
- bfredl/nvim-luadev
- SidOfc/mkdx
  - iamcco/markdown-preview.nvim
  - dhruvasagar/vim-table-mode
言語変更
- filetype 変更時に lsp, formatter 動的切り替え
- 無名ファイルでもフォーマッタ可能にしたい
postman 互換
lint
- ファイル変更時に throttle で実行
typescript
- eslint が deno の時は走らないように
- eslint エラーを検索したい
- eslint エラー名をヤンク
- eslint fix を実行

]]
