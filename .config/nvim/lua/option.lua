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
  fileformat = 'unix', -- 改行コードを LF に
  textwidth = 0, -- 一行の長さを無制限に (git commit message で自動改行されるのを防ぐ)
  foldmethod = 'indent', -- インデントで折りたたみができるように
  foldenable = false, -- ファイルを開いた時の自動折り畳みを無効化
  scrolloff = 5, -- 上下に 5 行の余裕を持ってカーソル移動
  list = true,
  listchars = { tab = '→→', trail = '␣', nbsp = '¤' },
  virtualedit = { 'block', 'onemore' }, -- 矩形選択時に行末を超えて選択できるように
  startofline = false, -- バッファ切替などした時にカーソル位置が変わらないように
  laststatus = 3, -- statusline を常に表示
  backupcopy = 'yes', -- バックアップファイルは基のファイルを再利用せず新しく作るようにする。これにより nvim で編集したファイルの inode が変化しない
  breakindent = true, -- 行折り返し表示もインデントされるように
  showbreak = '  > ', -- 行折り返しの追加表示
  fixendofline = false, -- 最終行への空行挿入を無効化
  splitbelow = true, -- 新規ウィンドウを下に表示
  splitright = true, -- 新規ウィンドウを右に表示
  diffopt = { 'indent-heuristic', unpack(vim.opt.diffopt:get()) },
}

for key, value in pairs(configs) do
  vim.opt[key] = value
end
