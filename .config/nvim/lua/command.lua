local util = require('util')
local stream = require('util/stream')

local commands = {
  rsib = {
    func = function()
      local name = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'):match('@name%s+([^%s]+)')
      if name == nil then
        return
      end
      require('plenary/job')
        :new({
          command = 'rsib',
          args = { 'exec', name },
        })
        :sync(1000 * 30)
    end,
  },
  totp = {
    func = function(opts)
      local target = opts.fargs[1]
      local password = vim.fn.inputsecret('password: ')
      local sysobj = vim.system({ 'totp', target }, { stdin = true })
      sysobj:write(password .. '\n')
      local otp = sysobj:wait().stdout:gsub('%s', '')
      vim.fn.setreg('*', otp)
    end,
    opts = { nargs = 1 },
  },
  ea = {
    func = function()
      stream
        .start(vim.api.nvim_list_bufs())
        .filter(function(bufnr)
          return vim.fn.buflisted(bufnr) == 1
        end)
        .for_each(function(bufnr)
          vim.api.nvim_buf_call(bufnr, function()
            pcall(vim.cmd.e)
          end)
        end)
    end,
  },
}

stream.for_each(commands, function(def, name)
  util.create_command_and_abbrev(name, def.func, def.opts)
end)
