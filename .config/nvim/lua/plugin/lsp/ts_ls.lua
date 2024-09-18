return function(server, lspconfig)
  local root_dir = lspconfig.util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json')
  local is_valid = root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
  server.setup({
    root_dir = root_dir,
    init_options = {},
    single_file_support = is_valid,
  })
end
