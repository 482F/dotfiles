-- プラグインの設定などを lazy に読み込まれる前に上書きしたいため lazy で管理しない
local util = require('util')

---@param path string
local function luafile(path)
  if not util.file_exists(path) then
    return
  end
  local success, result = pcall(function()
    vim.cmd.luafile(path)
  end)

  if not success then
    error(result)
  end
end

local cwd = vim.loop.cwd()
if cwd then
  for _, dir in pairs(util.ancestor_dirs(cwd)) do
    local config_path = dir .. 'nvim-config.lua'
    luafile(config_path)
  end
end
