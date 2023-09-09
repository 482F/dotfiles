return {
  'hrsh7th/nvim-cmp',
  dependencies = { 'hrsh7th/cmp-nvim-lsp' },
  event = 'VeryLazy',
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-o><C-o>'] = cmp.mapping.complete(),
        ['<C-o><C-a>'] = cmp.mapping.abort(),
        ['<C-o><C-m>'] = cmp.mapping.confirm({ select = true }),
      }),
      experimental = {
        ghost_text = true,
      },
    })
  end,
}
