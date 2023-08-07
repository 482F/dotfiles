local config = {
  cmd = {
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    '/home/normal/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar',

    '-configuration',
    '/home/normal/.local/share/jdtls/config_linux',

    '-data',
    '/home/normal/.local/share/nvim-jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
    '-Dhttps.proxyHost=172.21.252.1',
    '-Dhttp.proxyHost=172.21.252.1',
    '-Dhttps.proxyPort=12080',
    '-Dhttp.proxyPort=12080',
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  settings = {
    java = {},
  },
  init_options = {
    bundles = {},
  },
}
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'java',
  callback = function()
    require('jdtls').start_or_attach(config)
  end,
})
