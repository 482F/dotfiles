return {
  dir = '.',
  name = 'auto-executable',
  event = 'BufWritePre',
  config = function()
    local group = 'auto-executable'
    vim.api.nvim_create_augroup(group, {})
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      callback = function()
        local has_shebang = vim.api.nvim_buf_get_lines(0, 0, 1, true)[1]:match('^#!') ~= nil

        local fname = vim.fn.expand('%:p')
        local perm = vim.fn.getfperm(fname)
        local new_x
        if has_shebang then
          new_x = 'x'
        else
          new_x = '-'
        end
        local new_perm = perm:gsub('^(..).', '%1' .. new_x)

        if perm == new_perm then
          return
        end

        vim.fn.setfperm(fname, new_perm)
      end,
    })
  end,
}
