return {
  'hrsh7th/nvim-cmp',
  dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip' },
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
      confirmation = {
        get_commit_characters = function()
          return {}
        end,
      },
      experimental = {
        ghost_text = true,
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })
  end,
}
