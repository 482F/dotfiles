return function(server, lspconfig)
  local root_dir = lspconfig.util.root_pattern('deno.jsonc')
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
            ['https://cdn.nest.land'] = true,
            ['https://crux.land'] = true,
          },
        },
      },
    },
  })
end
