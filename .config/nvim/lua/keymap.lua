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

local function bd()
  vim.cmd.bnext()
  local closed, err = pcall(vim.cmd.bdelete, '#')
  if not closed then
    vim.cmd.bprev()
    error(err, 0)
  end
end
vim.keymap.set('n', '<leader>bd', bd, {
  desc = '現在のバッファを閉じる',
})
vim.keymap.set('n', '<leader>bz', function()
  vim.cmd.write()
  bd()
end, {
  desc = '現在のバッファを保存して閉じる',
})
vim.keymap.set('n', '<leader>b!', function()
  vim.cmd.bdelete({ bang = true })
end, { desc = '現在のバッファを保存せずに閉じる' })
vim.keymap.set('n', '<leader>bq', function()
  vim.cmd.bdelete()
end, { desc = '現在のバッファをウィンドウごと閉じる' })

-- インサートモードで括弧の中に入る/から出る
table.foreach({ '()', '{}', '[]', "''", '""', '``', '<>' }, function(_, surround)
  local left = surround:sub(1, 1)
  local right = surround:sub(2, 2)
  vim.keymap.set('i', left .. right .. 'H', left .. right .. '<Left>')
  vim.keymap.set('i', right .. 'L', '<Right>')
end)
