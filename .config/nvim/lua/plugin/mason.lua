return {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonInstall',
    'MasonUninstall',
    'MasonUninstallAll',
    'MasonLog',
    'MasonUpdate',
  },
  config = function()
    require('mason').setup()
  end,
}
