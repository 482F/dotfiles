local random = require('util/random')
local stream = require('util/stream')

local colorschemes = require('plugin/colorscheme/list')

math.randomseed(tonumber(os.date('%Y%m%d')) or 0)

local colorscheme_fns = stream
  .start(random.shuffle(colorschemes))
  .map_1nf(function(colorscheme)
    return colorscheme.names or { colorscheme.name }
  end)
  .map(function(e)
    local colorscheme = e[1]
    local name = e[2]
    return function()
      vim.cmd.colorscheme(name);
      (colorscheme.config or function() end)()

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
      return name
    end
  end)
  .terminate()

local i = 0

local function change_colorscheme()
  i = (i % #colorscheme_fns) + 1
  colorscheme_fns[i]()
  if i ~= 1 then
    require('plugin/mini/statusline').update_colorscheme()
  end
end

local plugins = stream.map(colorschemes, function(colorscheme, i)
  return stream.inserted_all(colorscheme, {
    [1] = colorscheme.repo,
    name = 'colorscheme-' .. colorscheme.repo:gsub('^[^%/]+/', ''),
    module = true,
    lazy = i ~= 1,
    config = i == 1 and function()
      change_colorscheme()
    end or function() end,
  })
end)

vim.keymap.set('n', '<leader><leader>cs', change_colorscheme, { desc = 'カラースキーム変更' })

-- -- plugins[1].config ではなく、autocmd で最初の適用をしたいが、何故か `Cannot find color scheme` エラーになる
-- -- 実行順的には plugin[1].config -> VeryLazy なので、何故前者でエラーにならないのか謎
-- vim.api.nvim_create_autocmd({ 'User' }, {
--   pattern = { 'VeryLazy' },
--   once = true,
--   callback = function()
--     vim.notify('LAZYVIMSTARTED')
--     change_colorscheme()
--   end,
-- })

math.randomseed(os.time())

return plugins
