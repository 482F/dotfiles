local mini_notify = require('mini.notify')
mini_notify.setup({
  lsp_progress = {
    enable = false,
  },
})
vim.notify = mini_notify.make_notify({
  INFO = { duration = 5000, hl_group = 'DiagnosticHint' },
})
