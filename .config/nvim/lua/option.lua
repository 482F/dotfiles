local stream = require('util/stream')

local configs = {
  encoding = 'utf-8', -- vim 内部のエンコーディング
  fileencodings = { 'utf-8', 'cp932' }, -- 読み込み時に試すエンコーディング
  fileencoding = 'utf-8', -- ファイル新規作成時の書き込みエンコーディング
  background = 'light', -- ライトモード
  expandtab = true, -- タブを半角スペースで入力
  shiftwidth = 2, -- インデント幅を 2 に
  undofile = true, -- ファイルを開き直しても変更履歴を保持
  timeout = false, -- キー入力のタイムアウト無効化
  number = true, -- 行番号表示
  signcolumn = 'number', -- エラー行などを行番号の場所で表示
  ignorecase = true, -- 検索時に大文字小文字を区別しない
  smartcase = true, -- 検索文字列に大文字が含まれるときは大文字小文字を区別する
  termguicolors = true, -- 色制限撤廃
}

stream.for_each(configs, function(value, key)
  vim.opt[key] = value
end)
