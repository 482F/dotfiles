local util = require('util/init')
local stream = require('util/stream')

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
  {
    key = 'D',
    write = false,
    bang = false,
    winclose = true,
    desc = '現在のバッファをウィンドウごと閉じる',
  },
  { key = 'z', write = true, bang = false, winclose = false, desc = '現在のバッファを保存して閉じる' },
  {
    key = 'Z',
    write = true,
    bang = false,
    winclose = true,
    desc = '現在のバッファを保存してウィンドウごと閉じる',
  },
  {
    key = 'q',
    write = false,
    bang = true,
    winclose = false,
    desc = '現在のバッファを保存せずに閉じる',
  },
  {
    key = 'Q',
    write = false,
    bang = true,
    winclose = true,
    desc = '現在のバッファを保存せずにウィンドウごと閉じる',
  },
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

for _, entry in pairs({
  { key = 'p', command = 'cprevious', desc = 'qflist の前の項目へ移動' },
  { key = 'n', command = 'cnext', desc = 'qflist の次の項目へ移動' },
  { key = 'o', command = 'copen', desc = 'qflist を開く' },
  { key = 'c', command = 'cclose', desc = 'qflist を閉じる' },
  {
    key = 'a',
    func = function()
      local qflist = vim.fn.getqflist()
      local qf = {
        bufnr = vim.fn.bufnr('%'),
        lnum = vim.fn.line('.'),
        col = vim.fn.col('.'),
        text = vim.fn.getline('.'),
        end_lnum = 0,
        end_col = 0,
        module = '',
        nr = 0,
        pattern = '',
        type = '',
        valid = 1,
        vcol = 0,
      }
      vim.fn.setqflist(stream.inserted_all(qflist, { qf }))
    end,
    desc = '現在行を qflist に追加する',
  },
  {
    key = 'd',
    func = function()
      util.remove_quickfix_by_bufnr_and_lnum(vim.fn.bufnr('%'), vim.fn.line('.'))
    end,
    desc = '現在行を qflist から削除する',
  },
}) do
  vim.keymap.set('n', '<leader>q' .. entry.key, entry.func == nil and function()
    vim.cmd[entry.command]()
  end or entry.func, { desc = entry.desc })
end

vim.keymap.set({ 'n', 'i' }, '<M-o>', function()
  -- TOOD: インデントをいい感じにするために色々やっているので重い。軽くしたい
  vim.cmd.normal('i\na\n')
  vim.cmd.normal('k==$x')
  vim.cmd.startinsert({ bang = true })
end, { desc = '現在のカーソル位置に改行を入れてインサートモードに遷移' })

for _, entry in pairs({
  {
    key = '<M-j>',
    func = function()
      vim.cmd.resize('-1')
    end,
    desc = 'ウィンドウの高さ -1',
  },
  {
    key = '<M-k>',
    func = function()
      vim.cmd.resize('+1')
    end,
    desc = 'ウィンドウの高さ +1',
  },
  {
    key = '<M-h>',
    func = function()
      vim.api.nvim_win_set_width(0, (vim.api.nvim_win_get_width(0) - 1))
    end,
    desc = 'ウィンドウの幅 -1',
  },
  {
    key = '<M-l>',
    func = function()
      vim.api.nvim_win_set_width(0, (vim.api.nvim_win_get_width(0) + 1))
    end,
    desc = 'ウィンドウの幅 +1',
  },
}) do
  vim.keymap.set('n', entry.key, entry.func, { desc = entry.desc })
end
