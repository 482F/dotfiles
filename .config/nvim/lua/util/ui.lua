local M = {}

local function multi_select(prompt, entries, callback)
  local stream = require('util/stream')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values

  pickers
    .new(require('telescope.themes').get_cursor({}), {
      prompt_title = prompt,
      sorter = conf.generic_sorter({}),
      finder = finders.new_table({
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.label,
            ordinal = entry.label,
          }
        end,
      }),
      attach_mappings = function()
        local actions = require('telescope/actions')
        local action_state = require('telescope/actions/state')
        actions.select_default:replace(function(bufnr)
          local picker = action_state.get_current_picker(bufnr)
          local results = stream
            .start({ picker:get_selection() })
            .inserted_all(picker:get_multi_selection())
            .uniquify(function(entry)
              return entry
            end)
            .map(function(entry)
              return entry.value
            end)
            .terminate()
          callback(results)
          callback = function() end
          actions.close(bufnr)
        end)
        local first = true
        actions.close:replace_map({
          [function()
            return first
          end] = function(bufnr)
            first = false
            actions.close(bufnr)
            callback({})
          end,
        })
        return true
      end,
    })
    :find()
end

function M.multi_select(prompt, entries, callback)
  local co
  if not callback then
    co = coroutine.running()
    if co then
      callback = function(item)
        coroutine.resume(co, item)
      end
    end
  end
  if co == nil and callback == nil then
    error('no thread and no callback')
  end
  callback = vim.schedule_wrap(callback)
  multi_select(prompt, entries, callback)
  if co then
    return coroutine.yield()
  end
end

return M
