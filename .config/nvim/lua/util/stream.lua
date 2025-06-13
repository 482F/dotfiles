--PASTE create_M_annotation RESULT
--
---@alias _stream { count: (fun(): integer), every: (fun(func: (fun(v: any, k: any): boolean)): boolean), filter: (fun(func: (fun(v: any, k: any): boolean)): _stream), find: (fun(func: (fun(v: any, k: any): boolean)): any), flat_map: (fun(func: (fun(v: any, k: any): any)): _stream), flatten: (fun(): _stream), for_each: (fun(func: (fun(v: any, k: any): any)): nil), from_pairs: (fun(): _stream), group_by: (fun(key_creator: (fun(v: any, k: any): any), value_creator?: (fun(v: any, k: any): any)): _stream), includes: (fun(search_element: (any)): any), inserted_all: (fun(t2: (table<any, any>), max_depth?: (integer)): _stream), is_empty: (fun(): string), join: (fun(sep: (string)): string), keys: (fun(): _stream), map: (fun(func: (fun(v: any, k: any): any)): _stream), map_1nf: (fun(func: (fun(v: any, k: any): any[])): _stream), pairs: (fun(): _stream), product: (fun(...: (table<any, any>)): _stream), reduce: (fun(func: (fun(prev: any, v: any, k: any): any), initial: (any)): any), slice: (fun(s?: (integer), e?: (integer)): _stream), some: (fun(func: (fun(v: any, k: any): boolean)): boolean), sorted: (fun(sorter: (fun(e1: { key: any, value: any }, e2: { key: any, value: any }): any)): _stream), uniquify: (fun(key_func?: (fun(v: any, k: any): any)): _stream), values: (fun(): _stream), terminate: (fun(): table<any, any>) }
---@alias _m { count: (fun(t: table<any, any>): integer), every: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): boolean), filter: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): table<any, any>), find: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): any), flat_map: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): table<any, any>), flatten: (fun(t: table<any, any>): table<any, any>), for_each: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): nil), from_pairs: (fun(t: table<any, any>): table<any, any>), group_by: (fun(t: table<any, any>, key_creator: (fun(v: any, k: any): any), value_creator?: (fun(v: any, k: any): any)): table<any, any>), includes: (fun(t: table<any, any>, search_element: (any)): any), inserted_all: (fun(t: table<any, any>, t2: (table<any, any>), max_depth?: (integer)): table<any, any>), is_empty: (fun(t: table<any, any>): string), join: (fun(t: table<any, any>, sep: (string)): string), keys: (fun(t: table<any, any>): table<any, any>), map: (fun(t: table<any, any>, func: (fun(v: any, k: any): any)): table<any, any>), map_1nf: (fun(t: table<any, any>, func: (fun(v: any, k: any): any[])): table<any, any>), pairs: (fun(t: table<any, any>): table<any, any>), product: (fun(t: table<any, any>, ...: (table<any, any>)): table<any, any>), reduce: (fun(t: table<any, any>, func: (fun(prev: any, v: any, k: any): any), initial: (any)): any), slice: (fun(t: table<any, any>, s?: (integer), e?: (integer)): table<any, any>), some: (fun(t: table<any, any>, func: (fun(v: any, k: any): boolean)): boolean), sorted: (fun(t: table<any, any>, sorter: (fun(e1: { key: any, value: any }, e2: { key: any, value: any }): any)): table<any, any>), uniquify: (fun(t: table<any, any>, key_func?: (fun(v: any, k: any): any)): table<any, any>), values: (fun(t: table<any, any>): table<any, any>), start: (fun(t: table<any, any>): _stream) }
--
--END

---@alias stream_info { value: any, key: any, result: { done: boolean, value: any }, consumed_elements: { value: any, key: any }[] }
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

intermediates.map_1nf = {}
---@param info stream_info
---@param func fun(v: any, k: any): any[]
function intermediates.map_1nf.main(info, func)
  local vals = func(info.value, info.key)

  local result = {}
  for _, val in pairs(vals) do
    table.insert(result, { info.value, val })
  end
  return result
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
  if not require('util').is_integer(info.key) or (s or 0) < 0 or (e or 0) < 0 then
    return {}
  end

  if s ~= nil and info.key < s then
    return {}
  end

  if e ~= nil and e <= info.key then
    return {}
  end

  return { info.value }
end
---@param info stream_info
---@param s? integer
---@param e? integer
function intermediates.slice.post(info, s, e)
  if 0 <= (s or 0) and 0 <= (e or 0) then
    return {}
  end

  local result = {}
  local count = #info.consumed_elements
  local function positivize(n)
    if n == nil then
      return n
    elseif n < 0 then
      return count + n + 1
    else
      return n
    end
  end
  local ps = positivize(s)
  local pe = positivize(e)
  for _, element in pairs(info.consumed_elements) do
    local value = intermediates.slice.main({ key = element.key, value = element.value }, ps, pe)[1]
    if value then
      table.insert(result, value)
    end
  end
  return result
end

intermediates.inserted_all = {}
---@param _ stream_info
---@param t2 table<any, any>
function intermediates.inserted_all.pre(_, t2)
  local result = {}
  for key, value in pairs(t2) do
    if not require('util').is_integer(key) then
      result[key] = value
    end
  end
  return result
end
---@param info stream_info
---@param t2 table<any, any>
---@param max_depth? integer
function intermediates.inserted_all.main(info, t2, max_depth)
  if require('util').is_integer(info.key) then
    return { info.value }
  end

  local fu = require('util/func')

  max_depth = max_depth or 1
  local value = fu.recursivize(function(self, v1, v2, depth)
    if (0 < max_depth and max_depth <= depth) or type(v1) ~= 'table' or type(v2) ~= 'table' then
      if v2 == nil then
        return v1
      else
        return v2
      end
    end

    local result = {}
    for key in pairs(vim.tbl_extend('force', v1, v2)) do
      if require('util').is_integer(key) then
        table.insert(result, v1[key])
        table.insert(result, v2[key])
      else
        result[key] = self(v1[key], v2[key], depth + 1)
      end
    end
    return result
  end)(info.value, t2[info.key], 1)

  return {
    [info.key] = value,
  }
end
---@param _ stream_info
---@param t2 table<any, any>
function intermediates.inserted_all.post(_, t2)
  local result = {}
  for key, value in pairs(t2) do
    if require('util').is_integer(key) then
      table.insert(result, value)
    end
  end
  return result
end

intermediates.flatten = {}
---@param info stream_info
function intermediates.flatten.main(info)
  local fu = require('util/func')
  return intermediates.flat_map.main(info, fu.identity)
end

intermediates.group_by = {}
---@param info stream_info
---@param key_creator fun(v: any, k: any): any
---@param value_creator? fun(v: any, k: any): any
function intermediates.group_by.post(info, key_creator, value_creator)
  local fu = require('util/func')
  value_creator = value_creator or fu.identity

  local grouped = {}
  for _, element in pairs(info.consumed_elements) do
    local groupkey = key_creator(element.value, element.key)
    grouped[groupkey] = grouped[groupkey] or {}
    table.insert(grouped[groupkey], value_creator(element.value))
  end
  return grouped
end

intermediates.sorted = {}
---@param info stream_info
---@param sorter fun(e1: { key: any, value: any }, e2: { key: any, value: any }): any
function intermediates.sorted.post(info, sorter)
  sorter = sorter
    or function(e1, e2)
      if e1.value < e2.value then
        return -1
      else
        return 1
      end
    end
  local fu = require('util/func')
  local sorted_elements = fu.recursivize(function(self, elements)
    local count = #elements
    if count <= 1 then
      return elements
    end

    local part = { {}, {} }
    for i = 1, count, 1 do
      table.insert(part[i % 2 + 1], elements[i])
    end

    local sorted_parts = { self(part[1]), self(part[2]) }
    local sorted = {}

    while 0 < #sorted_parts[1] or 0 < #sorted_parts[2] do
      local _, e1 = next(sorted_parts[1])
      local _, e2 = next(sorted_parts[2])
      local i
      if e1 == nil then
        i = 2
      elseif e2 == nil then
        i = 1
      else
        local diff = sorter(e1, e2)
        if diff < 0 then
          i = 1
        else
          i = 2
        end
      end

      table.insert(sorted, table.remove(sorted_parts[i], 1))
    end
    return sorted
  end)(info.consumed_elements)

  local sorted_values = {}
  for _, element in pairs(sorted_elements) do
    table.insert(sorted_values, element.value)
  end
  return sorted_values
end

intermediates.product = {}
---@param info stream_info
---@param ... table<any, any>
function intermediates.product.main(info, ...)
  local function product(accum, list)
    local result = {}
    for _, elements in pairs(accum) do
      for _, element in pairs(list) do
        local new = { unpack(elements) }
        table.insert(new, element)
        table.insert(result, new)
      end
    end
    return result
  end
  local accum = { { info.value } }
  for _, list in pairs({ ... }) do
    accum = product(accum, list)
  end
  return accum
end

intermediates.uniquify = {}

---@param info stream_info
---@param key_func? fun(v: any, k: any): any
function intermediates.uniquify.post(info, key_func)
  key_func = key_func or function(value)
    return value
  end

  local dict = {}

  local result = {}
  for _, element in pairs(info.consumed_elements) do
    local key = element.key
    local value = element.value

    local dictkey = key_func(value, key)
    if not dict[dictkey] then
      table.insert(result, value)
    end
    dict[dictkey] = true
  end
  return result
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
---@param _ stream_info
---@param _ any
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
---@param _ any
---@return { done: boolean, value: any }
function terminals.reduce.main(info, func)
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

terminals.is_empty = {}
---@return { done: boolean, value: string }
function terminals.is_empty.pre()
  return {
    done = false,
    value = true,
  }
end
---@return { done: boolean, value: string }
function terminals.is_empty.main()
  return {
    done = true,
    value = false,
  }
end

---@type _m
local M = {}

function M.start(t)
  local function create_operation(func, params)
    return {
      func = func,
      params = params,
      elements = {},
      is_init = true,
      is_consumed = false,
      consumed_elements = {},
    }
  end
  ---@alias fp fun(info: stream_info, ...: any[]): any
  ---@type { func: { pre: fp, main: fp, post: fp }, params: any[], elements: { key: any, value: any }[], is_init: boolean, is_consumed: boolean, consumed_elements: { key: any, value: any }[] }[]
  local operations = {}
  return setmetatable({}, {
    __index = function(self, name)
      local intermediate = intermediates[name]
      if intermediate then
        return function(...)
          table.insert(operations, create_operation(intermediate, { ... }))
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
        table.insert(operations, create_operation(terminal, { ... }))

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

          if element.key ~= nil then
            table.insert(operation.consumed_elements, element)
          end

          local info = {
            value = element.value,
            key = element.key,
            result = result,
            consumed_elements = operation.consumed_elements,
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
      local category, name = datum.line:match('function ([^%.]+)%.([^%.]+)%.([^%(]+)')
      if not category then
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
    .group_by(function(datum)
      return datum.category .. '.' .. datum.name
    end)
    .map(function(group)
      local first = group[1]
      local annotations = M.start(group)
        .flat_map(function(datum)
          return M.map(datum.annotations, function(annotation, i)
            return { i = i, annotation = annotation }
          end)
        end)
        .group_by(fu.picker('i'), fu.picker('annotation'))
        .map(function(annotations)
          return M.find(annotations, function(annotation)
            return annotation.category == 'return' or annotation.name ~= '_'
          end)
        end)
        .terminate()
      return {
        category = first.category,
        name = first.name,
        annotations = annotations,
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
        .join(', ')
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
    .sorted(function(e1, e2)
      if e1.value.name < e2.value.name then
        return -1
      else
        return 1
      end
    end)
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

-- vim.api.nvim_create_autocmd({ 'User' }, {
--   pattern = { 'VeryLazy' },
--   once = true,
--   callback = function()
--     vim.fn.setreg('*', create_M_annotation())
--   end,
-- })

return M
