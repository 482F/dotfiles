vim.cmd.colorscheme('quiet')

-- クリップボード共有設定
vim.opt.clipboard = 'unnamedplus'
if vim.fn.has('wsl') then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
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
