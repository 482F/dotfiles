return function(server, lspconfig)
  local util = require('util')

  local node_root_dir = lspconfig.util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json')
  local deno_root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
  local root_dir = function(path)
    if deno_root_dir(path) ~= nil then
      return nil
    end

    return node_root_dir(path)
  end
  local tsdk = vim.fn.join({ os.getenv('TSDK'), 'lib', 'node_modules', 'typescript', 'lib' }, util.path_delimiter)
  local is_valid = root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
  server.setup({
    root_dir = root_dir,
    single_file_support = is_valid,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    init_options = {
      typescript = {
        tsdk = tsdk,
      },
      vue = {
        hybridMode = false,
      },
    },
  })
end
