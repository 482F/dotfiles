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
    'flexoki',
  }),
  function(name, i)
    local plugin = require('plugin/colorscheme/' .. name)
    if i ~= 1 then
      plugin.module = true
      plugin.lazy = true
    end
    local name = plugin.name or string.gsub(plugin[1], '.*/', '')
    plugin.name = 'colorscheme-' .. name

    local original_config = plugin.config or function() end

    plugin.config = function()
      original_config()

      vim.tbl_map(
        function(entry)
          local name = entry[1]
          local def = entry[2]
          local cloned_def = vim.tbl_deep_extend('keep', {}, def)
          if cloned_def.italic then
            cloned_def.italic = false
          end
          if cloned_def.cterm and cloned_def.cterm.italic then
            cloned_def.cterm.italic = false
          end
          vim.api.nvim_set_hl(0, name, cloned_def)
        end,
        vim.tbl_filter(function(entry)
          local def = entry[2]
          return def.italic or def.cterm and def.cterm.italic
        end, stream.pairs(vim.api.nvim_get_hl(0, {})))
      )
    end

    return plugin
  end
)

vim.keymap.set('n', '<leader><leader>cs', function()
  local plugin = random.pick(plugins)
  plugin.config()
  require('plugin/mini/statusline').colorscheme = plugin.name:gsub('^colorscheme%-', ''):gsub('%.n?vim$', '')
end, { desc = 'カラースキーム変更' })

return plugins
