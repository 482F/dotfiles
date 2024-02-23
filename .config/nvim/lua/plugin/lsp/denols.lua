return function(server, lspconfig)
  local stream = require('util/stream')

  local root_dirs = stream.map({ 'deno.jsonc', 'deno.json' }, function(name)
    return lspconfig.util.root_pattern(name)
  end)
  local root_dir = function(...)
    local args = { ... }
    return stream
      .start(root_dirs)
      .map(function(rd)
        return rd(unpack(args))
      end)
      .find(function(v)
        return v
      end)
  end
  server.setup({
    root_dir = root_dir,
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
  })
end
