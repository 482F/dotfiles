local util = require('util')

vim.cmd.colorscheme('quiet')

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

---@generic T : unknown
---@param obj T
---@param regname? string default 's'
---@return T
function log(obj, regname)
  regname = regname or 's'
  local str = vim.inspect(obj)
  vim.notify(str)
  if regname ~= '' then
    vim.fn.setreg(regname, str, 'V')
  end
  return obj
end
