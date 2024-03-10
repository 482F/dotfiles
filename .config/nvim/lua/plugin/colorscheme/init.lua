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
        .for_each(function(def, hlname)
          local cloned_def = vim.tbl_deep_extend('keep', {}, def)
          if cloned_def.italic then
            cloned_def.italic = false
          end
          if cloned_def.cterm and cloned_def.cterm.italic then
            cloned_def.cterm.italic = false
          end
          vim.api.nvim_set_hl(0, hlname, cloned_def)
        end)

      local hl_name = stream.start({ 'MiniStatuslineModeNormal', 'Cursor' }).find(function(n)
        return vim.fn.hlID(n) ~= 0
      end)
      vim.api.nvim_set_hl(0, 'TabLine', { link = hl_name })
      vim.api.nvim_set_hl(0, 'TabLineFill', { link = hl_name })
      vim.api.nvim_set_hl(0, 'TabLineSel', { link = 'Normal' })
    end

    return plugin
  end
)

local i = 1

vim.keymap.set('n', '<leader><leader>cs', function()
  i = i + 1
  local plugin = plugins[(i % #plugins) + 1]
  plugin.config()
  require('plugin/mini/statusline').colorscheme = plugin.name:gsub('^colorscheme%-', ''):gsub('%.n?vim$', '')
end, { desc = 'カラースキーム変更' })

math.randomseed(os.time())

return plugins
