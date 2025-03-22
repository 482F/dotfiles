local util = require('util')
local stream = require('util/stream')

local dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
local files = vim
  .iter(vim.fs.dir(dir))
  :filter(function(name)
    return name:match('%.lua$')
  end)
  :filter(function(name)
    return name ~= 'init.lua'
  end)
  :totable()

local alldefs = stream
  .start(files)
  .map(function(file)
    return file[1]:gsub('%.lua$', '')
  end)
  .map(function(name)
    return 'plugin' .. util.path_delimiter .. 'ddc' .. util.path_delimiter .. name
  end)
  .map(function(lua_path)
    return require(lua_path)
  end)
  .terminate()

return {
  'Shougo/ddc.vim',
  dependencies = stream
    .start(alldefs)
    .map(function(def)
      return def.dependencies
    end)
    .inserted_all({
      'vim-denops/denops.vim',
      'Shougo/ddc-ui-pum',
      'Shougo/ddc-filter-sorter_rank',
      'Shougo/pum.vim',
      'tani/ddc-fuzzy',
    })
    .flatten()
    .uniquify()
    .terminate(),
  config = function()
    local options = stream
      .start(alldefs)
      .filter(function(def)
        return def.subkey == nil
      end)
      .map(function(def)
        return def.options
      end)
      .inserted_all({
        {
          ui = 'pum',
          sourceOptions = {
            _ = {
              minAutoCompleteLength = 1000,
              minManualCompleteLength = 0,
              timeout = 30000,
              ignoreCase = true,
              matchers = { 'matcher_fuzzy' },
              sorters = { 'sorter_rank' },
              converters = { 'converter_fuzzy' },
            },
          },
        },
      })
      .reduce(function(merged, option)
        return stream.inserted_all(merged, option, 0)
      end, {})
    vim.fn['ddc#custom#patch_global'](options)

    stream
      .start(alldefs)
      .filter(function(def)
        return def.init ~= nil
      end)
      .for_each(function(def)
        def.init()
      end)

    stream
      .start(alldefs)
      .filter(function(def)
        return def.subkey ~= nil
      end)
      .for_each(function(def)
        vim.keymap.set('i', '<F27>' .. def.subkey, function()
          vim.fn['ddc#hide']()
          vim.fn['ddc#map#manual_complete'](def.options)
        end)
      end)

    vim.fn['ddc#enable']()
    vim.keymap.set('i', '<Tab>', function()
      if vim.fn['ddc#visible']() then
        vim.fn['pum#map#select_relative'](1)
        return
      end

      local prev = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2])
      if prev:match('^%s*$') then
        return '<Tab>'
      end

      vim.fn['ddc#map#manual_complete']()
    end, { expr = true })
    vim.keymap.set('i', '<S-Tab>', function()
      if vim.fn['ddc#visible']() then
        vim.fn['pum#map#select_relative'](-1)
      else
        vim.fn['ddc#map#manual_complete']()
      end
    end)
    vim.keymap.set('i', '<CR>', function()
      if vim.fn['pum#complete_info']().selected == -1 then
        return '<CR>'
      else
        vim.fn['pum#map#confirm']()
      end
    end, { expr = true, noremap = false })
  end,
}
