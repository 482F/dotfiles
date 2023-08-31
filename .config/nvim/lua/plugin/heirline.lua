return {
  'rebelot/heirline.nvim',
  config = function()
    require('heirline').setup({
      -- statusline = {
      --   { -- VimMode
      --     hl = { fg = 'blue', bg = 'lightblue' },
      --     { -- ModeValue
      --       provider = function()
      --         return vim.fn.mode()
      --       end,
      --     },
      --     { -- Separator
      --       hl = { fg = 'lightblue', bg = 'gray' },
      --       provider = '\u{E0BC}',
      --     },
      --   },
      --   { -- FileName
      --     hl = { fg = 'black', bg = 'gray' },
      --     provider = function()
      --       return vim.fn.bufname()
      --     end,
      --   },
      -- },
    })
  end,
}
