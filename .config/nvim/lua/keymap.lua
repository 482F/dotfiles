vim.g.mapleader = ' '

-- コマンド履歴の前方一致検索キーをアローキーから入れ替え
vim.keymap.set('c', '<C-P>', '<UP>')
vim.keymap.set('c', '<C-N>', '<DOWN>')
vim.keymap.set('c', '<UP>', '<C-P>')
vim.keymap.set('c', '<DOWN>', '<C-N>')

-- 表示行の上下移動
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- タブ入れ替え
vim.keymap.set('n', 'S>', ':+tabm<CR>')
vim.keymap.set('n', 'S<', ':-tabm<CR>')

-- 検索時に正規表現有効化
vim.keymap.set('n', '/', '/\\v')

-- 置換
vim.keymap.set('n', '<C-H>', ':%s///gc<LEFT><LEFT><LEFT>')

-- 行末までヤンク
vim.keymap.set('n', 'Y', 'y$')

-- バッファ移動
vim.keymap.set('n', '<C-j>', ':bprev<CR>')
vim.keymap.set('n', '<C-k>', ':bnext<CR>')

