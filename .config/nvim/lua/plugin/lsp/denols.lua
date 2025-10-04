return function()
  return {
    root_dir = function(bufnr, callback)
      local util = require('util')
      local base = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)))

      local deno_dir = util.find_ancestors({ 'deno.json', 'deno.jsonc' }, base)[1]
      if deno_dir == nil then
        return
      end
      return callback(deno_dir)
    end,
    init_options = {
      lint = true,
      enable = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
            ['https://crux.land'] = false,
            ['https://x.nest.land'] = false,
          },
        },
      },
    },
  }
end
