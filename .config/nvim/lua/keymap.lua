local util = require('util')
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
util.set_repeat_keymap('n', 'S>', ':+tabm<CR>', { desc = '次のタブと入れ替え', silent = true })
util.set_repeat_keymap('n', 'S<', ':-tabm<CR>', { desc = '前のタブと入れ替え', silent = true })

-- 検索時に正規表現有効化
vim.keymap.set('n', '/', '/\\v', { desc = '正規表現を有効にして検索' })

-- 置換
vim.keymap.set('n', '<C-H>', ':%s///gc<LEFT><LEFT><LEFT>', { desc = '置換' })

-- 行末までヤンク
vim.keymap.set('n', 'Y', 'y$', { desc = '行末までヤンク' })

-- レジスタに入れずに削除
vim.keymap.set('n', 'x', '"_d')
vim.keymap.set('n', 'X', '"_D')
vim.keymap.set('x', 'x', '"_d')

-- WORD 選択
vim.keymap.set('o', 'i<space>', 'iW')
vim.keymap.set('x', 'i<space>', 'iW')

-- visual ヤンク時にカーソル維持
vim.keymap.set('x', 'y', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  vim.fn.feedkeys('"' .. vim.v.register .. 'y', 'nx')
  vim.api.nvim_win_set_cursor(0, cursor)
end)

-- ペースト時のカーソル位置を末尾に
stream.start({ 'n', 'x' }).product({ 'p', 'P' }).for_each(function(pair)
  local mode = pair[1]
  local key = pair[2]
  vim.keymap.set(mode, key, key .. '`]')
end)

-- バッファ移動
vim.keymap.set('n', '<C-j>', ':bnext<CR>', { desc = '前のバッファへ移動', silent = true })
vim.keymap.set('n', '<C-k>', ':bprev<CR>', { desc = '次のバッファへ移動', silent = true })

vim.keymap.set('x', '<Leader>q', function()
  vim.fn.feedkeys(':', 'nx') -- ビジュアルモード解除
  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")
  local text = vim.api.nvim_buf_get_lines(s[1], s[2] - 1, e[2], false)
  local script = stream
    .start({
      '(function()',
      '  local raw_result = (function()',
      text,
      '  end)()',
      '  local result = vim.inspect(raw_result)',
      '  vim.notify(result)',
      '  if result ~= "nil" then',
      '    vim.fn.setreg("*", result)',
      '  end',
      'end)()',
    })
    .flatten()
    .join('\n')
  vim.fn.luaeval(script)
end, { desc = 'lua スクリプト実行' })

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
    util.bd(entry.write, entry.bang, entry.winclose)
  end, { desc = entry.desc })
end

stream.for_each({
  { key = 'fp', str = '%:p', desc = 'ファイルパスをヤンク' },
  { key = 'fn', str = '%:t', desc = 'ファイル名をヤンク' },
}, function(entry)
  vim.keymap.set('n', '<leader>y' .. entry.key, function()
    vim.fn.setreg('*', vim.fn.expand(entry.str))
  end, { desc = entry.desc })
end)

for _, entry in pairs({
  {
    key = 'p',
    func = function()
      local success = pcall(vim.cmd.cprevious)
      if not success then
        vim.cmd.clast()
      end
    end,
    desc = 'qflist の前の項目へ移動',
  },
  {
    key = 'n',
    func = function()
      local success = pcall(vim.cmd.cnext)
      if not success then
        vim.cmd.cfirst()
      end
    end,
    desc = 'qflist の次の項目へ移動',
  },
  { key = 'o', command = 'copen', desc = 'qflist を開く' },
  { key = 'c', command = 'cclose', desc = 'qflist を閉じる' },
  {
    key = 'a',
    func = function()
      local qflist = vim.fn.getqflist()
      local qf = {
        bufnr = vim.fn.bufnr(),
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
      util.remove_quickfix_by_bufnr_and_lnum(vim.fn.bufnr(), vim.fn.line('.'))
    end,
    desc = '現在行を qflist から削除する',
  },
}) do
  vim.keymap.set('n', '<leader>q' .. entry.key, entry.func == nil and function()
    vim.cmd[entry.command]()
  end or entry.func, { desc = entry.desc })
end

vim.keymap.set({ 'n', 'i' }, '<M-o>', function()
  vim.cmd.normal('i\nz\n')
  vim.fn.feedkeys('k=="_cc', '')
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

vim.keymap.set('n', '<leader><leader>uo', function()
  util.open_url(vim.fn.getline('.'):match('https?:[^ <>&"\':]+'))
end, { desc = 'URL をブラウザで開く' })

-- gt の t 連打でタブ移動
util.set_repeat_keymap('n', 'gt', 'gt')
util.set_repeat_keymap('n', 'gT', 'gT')

vim.keymap.set('n', '<leader>br', function()
  local filepath = vim.fn.expand('%:p')
  if vim.fn.filereadable(filepath) == 0 then
    return
  end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local bufnr = vim.fn.bufnr()
  vim.cmd.bnext()
  pcall(function()
    vim.cmd.bwipeout(bufnr)
  end)
  vim.cmd.edit(filepath)
  vim.api.nvim_win_set_cursor(0, cursor)
end, { desc = 'バッファを開き直す' })

vim.keymap.set('i', '<C-x><C-a>', function()
  local prev = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2])
  local md_pattern = '(%d%d)[-/](%d%d)$'
  local y, m, d = prev:match('(%d%d%d%d)[-/]' .. md_pattern)
  if y == nil then
    y = os.date('%Y')
    m, d = prev:match(md_pattern)
  end

  if m == nil then
    return
  end

  local weekday = ({ '日', '月', '火', '水', '木', '金', '土' })[os.date(
    '*t',
    os.time({ year = y, month = m, day = d })
  ).wday]

  vim.api.nvim_input(' (' .. weekday .. ')')
end, { desc = '曜日を挿入' })
