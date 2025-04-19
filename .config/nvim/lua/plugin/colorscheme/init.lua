local random = require('util/random')
local stream = require('util/stream')

math.randomseed(tonumber(os.date('%Y%m%d')) or 0)

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
    'gruvbox',
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
  function(filename, i)
    local plugin = require('plugin/colorscheme/' .. filename)
    if i ~= 1 then
      plugin.module = true
      plugin.lazy = true
    end
    local name = plugin.name or string.gsub(plugin[1], '.*/', '')
    plugin.name = 'colorscheme-' .. name

    local original_config = plugin.config or function() end

    plugin.config = function()
      original_config()

      stream
        .start(vim.api.nvim_get_hl(0, {}))
        .filter(function(def)
          return def.italic or def.cterm and def.cterm.italic
        end)
        .map(function(def)
          return stream.inserted_all(def, { italic = false, cterm = { italic = false } }, 0)
        end)
        .for_each(function(def, hlname)
          vim.api.nvim_set_hl(0, hlname, def)
        end)

      local tab_hl_name = stream.start({ 'MiniStatuslineModeNormal', 'Cursor' }).find(function(n)
        return vim.fn.hlID(n) ~= 0
      end)
      vim.api.nvim_set_hl(0, 'TabLine', { link = tab_hl_name })
      vim.api.nvim_set_hl(0, 'TabLineFill', { link = tab_hl_name })
      vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'Normal' })

      vim.api.nvim_set_hl(0, 'TelescopeSelection', { link = 'Visual' })
    end

    return plugin
  end
)

local i = 1

vim.keymap.set('n', '<leader><leader>cs', function()
  i = (i % #plugins) + 1
  local plugin = plugins[i]
  plugin.config()
  require('plugin/mini/statusline').colorscheme = plugin.name:gsub('^colorscheme%-', ''):gsub('%.n?vim$', '')
end, { desc = 'カラースキーム変更' })

math.randomseed(os.time())

return plugins
