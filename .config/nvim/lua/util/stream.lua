--PASTE create_M_annotation RESULT
--
---@alias _stream { map: (fun(func: (fun(v: any, k: any): any)): _stream), flat_map: (fun(func: (fun(v: any, k: any): any)): _stream), filter: (fun(func: (fun(v: any, k: any): boolean)): _stream), from_pairs: (fun(): _stream), pairs: (fun(): _stream), keys: (fun(): _stream), values: (fun(): _stream), slice: (fun(s?: (integer),e?: (integer)): _stream), inserted_all: (fun(t2: (table<any, any>)): _stream), for_each: (fun(func: (fun(v: any, k: any): any)): nil), reduce: (fun(func: (fun(prev: any, v: any, k: any): any),initial: (any)): any), includes: (fun(search_element: (any)): any), find: (fun(func: (fun(v: any, k: any): boolean)): any), some: (fun(func: (fun(v: any, k: any): boolean)): boolean), every: (fun(func: (fun(v: any, k: any): boolean)): boolean), count: (fun(): integer), join: (fun(sep: (string)): string), terminate: (fun(): table<any, any>) }
---@alias _m { map: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): table<any, any>), flat_map: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): table<any, any>), filter: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): table<any, any>), from_pairs: (fun(t: table<any, any>): table<any, any>), pairs: (fun(t: table<any, any>): table<any, any>), keys: (fun(t: table<any, any>): table<any, any>), values: (fun(t: table<any, any>): table<any, any>), slice: (fun(t: table<any, any>, s?: (integer),e?: (integer)): table<any, any>), inserted_all: (fun(t: table<any, any>, t2: (table<any, any>)): table<any, any>), for_each: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): nil), reduce: (fun(t: table<any, any>, func: (fun(prev: any, v: any, k: any): any),initial: (any)): any), includes: (fun(t: table<any, any>, search_element: (any)): any), find: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): any), some: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): boolean), every: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): boolean), count: (fun(t: table<any, any>): integer), join: (fun(t: table<any, any>, sep: (string)): string), start: (fun(t: table<any, any>): _stream) }
--
--END

---@alias stream_info { value: any, key: any, result: { done: boolean, value: any } }
local intermediates = {}
local terminals = {}

intermediates.map = {}
---@param info stream_info
---@param func fun(v: any, k: any): any
function intermediates.map.main(info, func)
  return { [info.key] = func(info.value, info.key) }
end

intermediates.flat_map = {}
---@param info stream_info
---@param func fun(v: any, k: any): any
function intermediates.flat_map.main(info, func)
  local newvals = func(info.value, info.key)
  if type(newvals) ~= 'table' then
    newvals = { [info.key] = newvals }
  end
  return newvals
end

intermediates.filter = {}
---@param info stream_info
---@param func fun(v: any, k: any): boolean
function intermediates.filter.main(info, func)
  if func(info.value, info.key) then
    return { [info.key] = info.value }
  else
    return {}
  end
end

intermediates.from_pairs = {}
---@param info stream_info
function intermediates.from_pairs.main(info)
  return { [info.value[1]] = info.value[2] }
end

intermediates.pairs = {}
---@param info stream_info
function intermediates.pairs.main(info)
  return { { info.key, info.value } }
end

intermediates.keys = {}
---@param info stream_info
function intermediates.keys.main(info)
  return { info.key }
end

intermediates.values = {}
---@param info stream_info
function intermediates.values.main(info)
  return { info.value }
end

intermediates.slice = {}
---@param info stream_info
---@param s? integer
---@param e? integer
function intermediates.slice.main(info, s, e)
  if not require('util').is_integer(info.key) then
    return {}
  end

  if s ~= nil and info.key < s then
    return {}
  end

  if e ~= nil then
    if 0 <= e and e <= info.key then
      return {}
    elseif e < 0 then
      -- 要素を一つずつ処理する都合上、今の要素が配列の終わりから何番目かを取得する方法がない
      error('minus e is not allowed!')
    end
  end

  return { info.value }
end

intermediates.inserted_all = {}
---@param info stream_info
---@param t2 table<any, any>
function intermediates.inserted_all.main(info, t2)
  return { [info.key] = info.value }
end
---@param _ stream_info
---@param t2 table<any, any>
function intermediates.inserted_all.post(_, t2)
  return t2
end

terminals.for_each = {}
---@param info stream_info
---@param func fun(v: any, k: any): any
---@return { done: boolean, value: nil }
function terminals.for_each.main(info, func)
  func(info.value, info.key)
  return {
    done = false,
  }
end

terminals.reduce = {}
---@param initial any
---@return { done: boolean, value: any }
function terminals.reduce.pre(_, _, initial)
  return {
    done = false,
    value = initial,
  }
end
---@param info stream_info
---@param func fun(prev: any, v: any, k: any): any
---@param initial any
---@return { done: boolean, value: any }
function terminals.reduce.main(info, func, initial)
  return {
    done = false,
    value = func(info.result.value, info.value, info.key),
  }
end

terminals.includes = {}
---@return { done: boolean, value: any }
function terminals.includes.pre()
  return {
    done = false,
    value = false,
  }
end
---@param info stream_info
---@param search_element any
---@return { done: boolean, value: any }
function terminals.includes.main(info, search_element)
  local result = info.value == search_element
  return {
    done = result,
    value = result,
  }
end

terminals.find = {}
---@return { done: boolean, value: any }
function terminals.find.pre()
  return {
    done = false,
    value = nil,
  }
end
---@param info stream_info
---@param func fun(v: any, k: any): boolean
---@return { done: boolean, value: any }
function terminals.find.main(info, func)
  local result = func(info.value, info.key)
  return {
    done = result,
    value = result and info.value or nil,
  }
end

terminals.some = {}
---@return { done: boolean, value: boolean }
function terminals.some.pre()
  return {
    done = false,
    value = terminals.find.pre().value ~= nil,
  }
end
---@param info stream_info
---@param func fun(v: any, k: any): boolean
---@return { done: boolean, value: boolean }
function terminals.some.main(info, func)
  local result = terminals.find.main(info, func)
  return {
    done = result.done,
    value = result.value ~= nil,
  }
end

terminals.every = {}
---@return { done: boolean, value: boolean }
function terminals.every.pre()
  return {
    done = false,
    value = not terminals.some.pre().value,
  }
end
---@param info stream_info
---@param func fun(v: any, k: any): boolean
---@return { done: boolean, value: boolean }
function terminals.every.main(info, func)
  local result = terminals.some.main(info, require('util/func').negate(func))
  return {
    done = result.done,
    value = not result.value,
  }
end

terminals.count = {}
---@return { done: boolean, value: integer }
function terminals.count.pre()
  return {
    done = false,
    value = 0,
  }
end
---@param info stream_info
---@return { done: boolean, value: integer }
function terminals.count.main(info)
  return {
    done = false,
    value = info.result.value + 1,
  }
end

terminals.join = {}
---@return { done: boolean, value: string }
function terminals.join.pre()
  return {
    done = false,
    value = '',
  }
end
---@param info stream_info
---@param sep string
---@return { done: boolean, value: string }
function terminals.join.main(info, sep)
  return {
    done = false,
    value = info.result.value .. sep .. info.value,
  }
end
---@param info stream_info
---@param sep string
---@return { done: boolean, value: string }
function terminals.join.post(info, sep)
  return {
    done = false,
    value = info.result.value:sub(sep:len() + 1),
  }
end

---@type _m
local M = {}

function M.start(t)
  ---@type { func: fun(info: stream_info, ...: any[]): any, params: any[], elements: { key: any, value: any }[], is_init: boolean, is_consumed: boolean }
  local operations = {}
  return setmetatable({}, {
    __index = function(self, name)
      local intermediate = intermediates[name]
      if intermediate then
        return function(...)
          table.insert(operations, {
            func = intermediate,
            params = { ... },
            elements = {},
            is_init = true,
            is_consumed = false,
          })
          return self
        end
      end

      local terminal
      if name == 'terminate' then
        terminal = {
          pre = function()
            return {
              done = false,
              value = {},
            }
          end,
          main = function(info)
            local prevtable = info.result.value
            local newtable
            if require('util').is_integer(info.key) then
              newtable = { [#prevtable + 1] = info.value }
            else
              newtable = { [info.key] = info.value }
            end
            return {
              done = false,
              value = vim.tbl_extend('force', prevtable or {}, newtable),
            }
          end,
        }
      else
        terminal = terminals[name]
      end

      if not terminal then
        return nil
      end

      return function(...)
        table.insert(operations, {
          func = terminal,
          params = { ... },
          elements = {},
          is_init = true,
          is_consumed = false,
        })

        operations[1].elements = {}
        for key, value in pairs(t) do
          table.insert(operations[1].elements, { key = key, value = value })
        end
        local result = { done = false, value = nil }
        local i = 1

        while true do
          ::continue::

          if i <= 0 then
            break
          end

          local operation = operations[i]
          local next_operation = operations[i + 1]

          ---@type fun(...: any[]): nil
          local modify_state
          if next_operation then
            modify_state = function(processed_values)
              for key, value in pairs(processed_values or {}) do
                table.insert(next_operation.elements, { key = key, value = value })
              end

              i = i + 1
            end
          else
            modify_state = function(new_result)
              result = new_result or result
            end
          end

          local element
          if operation.is_init then
            element = {}
          else
            element = table.remove(operation.elements, 1)
          end

          if not element then
            if not operation.is_consumed and (operations[i - 1] or { is_consumed = true }).is_consumed then
              element = {}
              operation.is_consumed = true
            else
              i = i - 1
              goto continue
            end
          end

          local info = {
            value = element.value,
            key = element.key,
            result = result,
          }
          local func
          if operation.is_init then
            func = operation.func.pre
          elseif operation.is_consumed then
            func = operation.func.post
          else
            func = operation.func.main
          end
          func = func or function(_, _)
            return nil
          end

          operation.is_init = false

          modify_state(func(info, unpack(operation.params)))
          if result.done then
            break
          end
        end
        return result.value
      end
    end,
  })
end

M.start({
  {
    func_map = intermediates,
    post_process = function(s)
      return s.terminate()
    end,
  },
  {
    func_map = terminals,
    post_process = function(s)
      return s
    end,
  },
})
  .flat_map(function(datum)
    return M.start(datum.func_map)
      .flat_map(function(_, name)
        return {
          [name] = function(t, ...)
            return datum.post_process(M.start(t)[name](...))
          end,
        }
      end)
      .terminate()
  end)
  .for_each(function(unit, name)
    M[name] = unit
  end)

local function create_M_annotation()
  local fu = require('util/func')

  ---@type string[]
  local self = vim.fn.readfile(debug.getinfo(1, 'S').source:sub(2))

  local function_infos = M.start(self)
    .map(function(line, i)
      return { line = line, i = i }
    end)
    .filter(function(datum)
      return M.some({ 'intermediates', 'terminals' }, function(category)
        return datum.line:find('function ' .. category, 1, true)
      end)
    end)
    .map(function(datum)
      local category, name, phase = datum.line:match('function ([^%.]+)%.([^%.]+)%.([^%(]+)')
      if not category or phase ~= 'main' then
        return nil
      end

      local raw_annotations = {}
      local j = datum.i - 1
      while true do
        local annotation = self[j]
        if annotation:find('---@', 1, true) ~= 1 then
          break
        end
        table.insert(raw_annotations, 1, annotation)
        j = j - 1
      end

      return {
        category = category,
        name = name,
        annotations = M.start(raw_annotations)
          .map(function(raw_annotation)
            local annotation_category, a1, a2 = raw_annotation:match('^%-%-%-@([^ ]+) ([^ ]+) ?(.*)')
            if annotation_category == 'param' then
              return { category = annotation_category, name = a1, type = a2 }
            elseif annotation_category == 'return' then
              return { category = annotation_category, type = a1 .. ' ' .. a2 }
            end
          end)
          .filter(fu.is_truthy)
          .terminate(),
      }
    end)
    .filter(fu.is_truthy)
    .map(function(datum)
      local params = M.start(datum.annotations)
        .filter(function(annotation)
          return annotation.type ~= 'stream_info' and annotation.category == 'param'
        end)
        .map(function(annotation)
          return annotation.name .. ': (' .. annotation.type .. ')'
        end)
        .join(',')
      if datum.category == 'intermediates' then
        return { name = datum.name, params = params }
      elseif datum.category == 'terminals' then
        local return_annotation = M.find(datum.annotations, function(annotation)
          return annotation.category == 'return'
        end)
        local return_type = return_annotation.type:match('value: (.+)}$'):sub(1, -2)
        return { name = datum.name, params = params, return_type = return_type }
      end
    end)
    .filter(fu.is_truthy)
    .terminate()
  local start_annotation = M.join({
    '---@alias _stream { ' .. M.start(function_infos)
      .map(function(info)
        return info.name .. ': (fun(' .. info.params .. '): ' .. (info.return_type or '_stream') .. ')'
      end)
      .inserted_all({ 'terminate: (fun(): table<any, any>)' })
      .join(', ') .. ' }',
  }, '\n')
  local unit_annotation = '---@alias _m { '
    .. M.start(function_infos)
      .map(function(info)
        return info.name
          .. ': (fun(t: table<any, any>'
          .. (info.params:len() == 0 and '' or ', ')
          .. info.params
          .. '): '
          .. (info.return_type or 'table<any, any>')
          .. ')'
      end)
      .inserted_all({ 'start: (fun(t: table<any, any>): _stream)' })
      .join(', ')
    .. ' }'

  return start_annotation .. '\n' .. unit_annotation
end
-- vim.fn.setreg('*', create_M_annotation())

return M
