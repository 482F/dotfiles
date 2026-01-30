return function()
  local util = require('util')

  local vue_language_server_path = vim.fn.join({
    os.getenv('VLS'),
    'lib',
    'language-tools',
    'packages',
    'language-server',
    'node_modules',
    '@vue',
    'typescript-plugin',
  }, util.path_delimiter)
  local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
  }

  return {
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },

    settings = {
      typescript = {
        preferences = {
          preferTypeOnlyAutoImports = { enabled = true },
        },
      },
      vtsls = {
        tsserver = {
          globalPlugins = {
            vue_plugin,
          },
        },
      },
    },
    single_file_support = true,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
  }
end
