local random = require('util/random')
local stream = require('util/stream')

local plugins = stream.map(
  random.shuffle({
    'catppuccin',
    'mini-base16',
    'everforest',
    'stylus',
    'rose-pine',
    'tokyonight',
    'solarized',
    'aquarium',
    'gruvbox-flat',
    'space-vim-theme',
    'toast',
    'cake16',
    'caret',
    'leaf',
    'melange',
    'atlas',
    'nord',
    'nightfox',
  }),
  function(name, i)
    local plugin = require('plugin/colorscheme/' .. name)
    if i ~= 1 then
      plugin.cond = false
    end
    local name = plugin.name or string.gsub(plugin[1], '.*/', '')
    plugin.name = 'colorscheme-' .. name
    return plugin
  end
)

local plugin = plugins[1]
plugin.dependencies = stream.inserted_all(plugin.dependencies or {}, stream.slice(plugins, 2))

return plugin
