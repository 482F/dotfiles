local stream = require('util/stream')

local commands = {
  Rsib = {
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
  Totp = {
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
}

stream.for_each(commands, function(def, name)
  vim.api.nvim_create_user_command(name, def.func, def.opts or {})
end)
