vim.api.nvim_create_user_command('Rsib', function()
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
end, {})
