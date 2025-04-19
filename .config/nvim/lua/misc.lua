local util = require('util')

vim.cmd.colorscheme('quiet')

local function clip(lines, regtype)
  local body = vim.fn.join(lines, '\n')
  vim.fn.chansend(vim.v.stderr, vim.fn.printf('\x1b]52;;%s\x1b\\', vim.fn.system('base64', body))) -- osc52 によるコピー
  vim.fn.system('win32yank.exe -i --crlf', body) -- win32yank によるコピー
end

-- クリップボード共有設定
vim.opt.clipboard = 'unnamedplus'
if util.is_wsl then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = clip,
      ['*'] = clip,
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enable = 1,
  }
end

-- git commit 時に
-- - editorconfig を無視
-- - 改行コードを LF 強制
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'diff' },
  callback = function()
    vim.g.editorconfig = false
    vim.opt.fileformat = 'unix'
    vim.opt.textwidth = 0
  end,
})

-- 最初に開いたファイルの親ディレクトリを作業ディレクトリにする
local parent_dir = vim.fn.expand('%:h')
if parent_dir ~= '' then
  vim.cmd.cd(parent_dir)
end

-- rg が使えれば :grep で使うように
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

vim.cmd.cabbrev('h', 'tab help')

vim.diagnostic.config({ severity_sort = true })
