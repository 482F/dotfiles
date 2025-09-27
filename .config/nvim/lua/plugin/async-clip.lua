return {
  '482F/async-clip.nvim',
  config = function()
    -- クリップボード共有設定
    vim.opt.clipboard = 'unnamedplus'

    local util = require('util')
    if not util.is_wsl then
      return
    end

    local async = require('plenary.async')
    local system = async.wrap(vim.system, 3)

    local async_clip = require('async-clip')

    local copy = async_clip.make_copy_fn(function(lines, regtype)
      local body = vim.fn.join(lines, '\n')
      -- system({ 'sleep', '1' })
      -- async.util.scheduler()
      local chan = '\x1b]52;;' .. vim.base64.encode(body) .. '\x1b\\'
      vim.fn.chansend(vim.v.stderr, chan) -- osc52 によるコピー
      async.util.scheduler()
      system({ 'win32yank.exe', '-i', '--crlf' }, { stdin = body }) -- win32yank によるコピー
    end, { allow_skip = true })

    local paste = async_clip.make_paste_fn(function()
      local body = vim.system({ 'win32yank.exe', '-o', '--lf' }, { text = true }):wait().stdout or ''
      ---@type string[]
      local lines = vim.fn.split(body, '\n', true)
      local regtype = 'v'
      if body == vim.fn.getreg('"') then
        regtype = vim.fn.getreginfo('"').regtype
      elseif lines[#lines] == '' then
        regtype = 'V'
      elseif lines[1] == '' then
        regtype = 'V'
        table.insert(lines, '')
        lines = vim.fn.slice(lines, 1, #lines)
      end
      return { lines, regtype }
    end, { timeout = 2000 })

    vim.g.clipboard = {
      name = 'async-win32yank-wsl',
      copy = {
        ['+'] = copy,
        ['*'] = copy,
      },
      paste = {
        ['+'] = paste,
        ['*'] = paste,
      },
      cache_enable = 1,
    }
  end,
}
