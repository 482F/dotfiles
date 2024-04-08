local assert = require('luassert')
local say = require('say')
local stream = require('util/stream')

say:set('assertion.has_values.positive', 'Expected %s \nto have values: %s')
say:set('assertion.has_values.negative', 'Expected %s \nto not have values: %s')
assert:register('assertion', 'has_values', function(_, args)
  if type(args[1]) ~= 'table' or #args <= 1 then
    return false
  end

  return stream.start(args).slice(2).every(function(expected)
    return stream.some(args[1], function(actual)
      return require('luassert.util').deepcompare(actual, expected)
    end)
  end)
end, 'assertion.has_values.positive', 'assertion.has_values.negative')

local launchers = {}
vim.keymap.set('n', '<leader>rt', function()
  local launcher = stream.find(launchers, function(launcher)
    return launcher.condition()
  end)
  if launcher == nil then
    return
  end

  local command = launcher.command()
  if command == nil then
    return
  end

  local name = 'nvim-test-rt'
  vim.cmd.edit(name)
  if vim.fn.bufname() == name then
    require('util').bd(false, false, false)
  end
  vim.cmd.terminal(command)
  vim.cmd.file(name)
end)

function assert.register_launcher(name, condition, command)
  launchers[name] = {
    condition = condition,
    command = command,
  }
end

return assert
