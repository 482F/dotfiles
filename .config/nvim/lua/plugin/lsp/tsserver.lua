return function(server, lspconfig)
  server.setup({
    root_dir = lspconfig.util.root_pattern('tsconfig.json'),
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
