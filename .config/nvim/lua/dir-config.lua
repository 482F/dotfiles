-- プラグインの設定などを lazy に読み込まれる前に上書きしたいため lazy で管理しない
---@param path string
local function luafile(path)
  local success, result = pcall(function()
    vim.cmd.luafile(path)
  end)
  if not success and not (result or ''):find('cannot open ' .. path .. ': No such file or directory', 1, true) then
    error(result)
  end
end

local util = require('util/init')

for _, dir in pairs(util.ancestor_dirs(vim.loop.cwd())) do
  local config_path = dir .. 'nvim-config.lua'
  luafile(config_path)
end
