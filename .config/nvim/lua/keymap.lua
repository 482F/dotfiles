vim.g.mapleader = ' '

-- コマンド履歴の前方一致検索キーをアローキーから入れ替え
vim.keymap.set('c', '<C-P>', '<UP>', { desc = '前方一致で履歴検索' })
vim.keymap.set('c', '<C-N>', '<DOWN>', { desc = '前方一致で履歴検索' })
vim.keymap.set('c', '<UP>', '<C-P>', { desc = '履歴検索' })
vim.keymap.set('c', '<DOWN>', '<C-N>', { desc = '履歴検索' })

-- 表示行の上下移動
vim.keymap.set('n', 'k', 'gk', { desc = '表示行で上に移動' })
vim.keymap.set('n', 'j', 'gj', { desc = '表示行で下に移動' })

-- タブ入れ替え
vim.keymap.set('n', 'S>', ':+tabm<CR>', { desc = '次のタブと入れ替え', silent = true })
vim.keymap.set('n', 'S<', ':-tabm<CR>', { desc = '前のタブと入れ替え', silent = true })

-- 検索時に正規表現有効化
vim.keymap.set('n', '/', '/\\v', { desc = '正規表現を有効にして検索' })

-- 置換
vim.keymap.set('n', '<C-H>', ':%s///gc<LEFT><LEFT><LEFT>', { desc = '置換' })

-- 行末までヤンク
vim.keymap.set('n', 'Y', 'y$', { desc = '行末までヤンク' })

-- バッファ移動
vim.keymap.set('n', '<C-j>', ':bprev<CR>', { desc = '前のバッファへ移動', silent = true })
vim.keymap.set('n', '<C-k>', ':bnext<CR>', { desc = '次のバッファへ移動', silent = true })

vim.keymap.set('x', '<Leader>q', ':source<CR>', { desc = 'lua スクリプト実行', silent = true })

---@param write boolean
---@param bang boolean
---@param winclose boolean
local function bd(write, bang, winclose)
  if write then
    vim.cmd.write()
  end

  if winclose then
    vim.cmd.bdelete({ args = { '%' }, bang = bang })
    return
  end

  vim.cmd.bnext()
  local closed, err = pcall(vim.cmd.bdelete, { args = { '#' }, bang = bang })
  if not closed then
    vim.cmd.bprev()
    error(err, 0)
  end
end

for _, entry in pairs({
  { key = 'd', write = false, bang = false, winclose = false, desc = '現在のバッファを閉じる' },
  { key = 'D', write = false, bang = false, winclose = true, desc = '現在のバッファをウィンドウごと閉じる' },
  { key = 'z', write = true, bang = false, winclose = false, desc = '現在のバッファを保存して閉じる' },
  { key = 'Z', write = true, bang = false, winclose = true, desc = '現在のバッファを保存してウィンドウごと閉じる' },
  { key = 'q', write = false, bang = true, winclose = false, desc = '現在のバッファを保存せずに閉じる' },
  { key = 'Q', write = false, bang = true, winclose = true, desc = '現在のバッファを保存せずにウィンドウごと閉じる' },
}) do
  vim.keymap.set('n', '<leader>b' .. entry.key, function()
    bd(entry.write, entry.bang, entry.winclose)
  end, { desc = entry.desc })
end

-- インサートモードで括弧の中に入る/から出る
table.foreach({ '()', '{}', '[]', "''", '""', '``', '<>' }, function(_, surround)
  local left = surround:sub(1, 1)
  local right = surround:sub(2, 2)
  vim.keymap.set('i', left .. right .. 'H', left .. right .. '<Left>')
  vim.keymap.set('i', right .. 'L', '<Right>')
end)

table.foreach({
  { key = 'fp', str = '%:p', desc = 'ファイルパスをヤンク' },
  { key = 'fn', str = '%:t', desc = 'ファイル名をヤンク' },
}, function(_, entry)
  vim.keymap.set('n', '<leader>y' .. entry.key, function()
    vim.fn.setreg('*', vim.fn.expand(entry.str))
  end, { desc = entry.desc })
end)
