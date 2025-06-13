return {
  { repo = 'folke/tokyonight.nvim', name = 'tokyonight' },
  { repo = 'rose-pine/neovim', name = 'rose-pine' },
  { repo = 'maxmx03/solarized.nvim', name = 'solarized' },
  { repo = 'EdenEast/nightfox.nvim', name = 'dayfox' },
  { repo = 'ellisonleao/gruvbox.nvim', name = 'gruvbox' },
  { repo = 'savq/melange-nvim', name = 'melange' },
  { repo = 'projekt0n/caret.nvim', name = 'caret' },
  { repo = 'jsit/toast.vim', name = 'toast' },
  { repo = 'shaunsingh/nord.nvim', name = 'nord' },
  {
    repo = 'liuchengxu/space-vim-theme',
    name = 'space-vim-theme',
    config = function()
      vim.cmd.colorscheme('space_vim_theme')
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#E5DCCE' })
    end,
  },
  {
    repo = 'echasnovski/mini.base16',
    name = 'mini-base16',
    config = function()
      require('mini.base16').setup({
        palette = {
          -- Default Background
          base00 = '#edece8',
          -- Lighter Background (Used for status bars, line number and folding marks)
          base01 = '#e6e6e6',
          -- Selection Background
          base02 = '#babab6',
          -- Comments, Invisible, Line Highlighting
          base03 = '#848089',
          -- Dark Foreground (Used for status bars)
          base04 = '#000000',
          -- Default Foreground, Caret, Delimiters, Operators
          base05 = '#2b2b2b',
          -- Light Foreground (Not often used)
          base06 = '#40403e',
          -- Light Background (Not often used)
          base07 = '#ffffff',
          -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
          base08 = '#a72817',
          -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
          base09 = '#476857',
          -- Classes, Markup Bold, Search Text Background
          base0A = '#575807',
          -- Strings, Inherited Class, Markup Code, Diff Inserted
          base0B = '#477817',
          -- Support, Regular Expressions, Escape Characters, Markup Quotes
          base0C = '#972867',
          -- Functions, Methods, Attribute IDs, Headings
          base0D = '#472877',
          -- Keywords, Storage, Selector, Markup Italic, Diff Changed
          base0E = '#773817',
          -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
          base0F = '#000000',
        },
        use_cterm = true,
      })

      -- 検索結果の色が見辛いので変更
      vim.api.nvim_set_hl(0, 'Search', {
        bg = '#ace3fd',
        fg = '#000000',
      })

      -- ウィンドウ区切り線の背景色を Normal と同じに
      local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
      vim.api.nvim_set_hl(0, 'WinSeparator', { bg = normal.bg })
    end,
  },
  {
    repo = 'neanias/everforest-nvim',
    name = 'everforest',
    config = function()
      vim.cmd.colorscheme('everforest')
      require('everforest').setup({
        background = 'hard',
      })
    end,
  },
  {
    repo = 'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'latte',
      })
      vim.cmd.colorscheme('catppuccin')
    end,
  },
  {
    repo = 'FrenzyExists/aquarium-vim',
    name = 'aquarium',
    config = function()
      vim.cmd.colorscheme('aquarium')
      vim.cmd.highlight('Comment', 'guifg=#9CA6B9')
      vim.cmd.highlight('DiagnosticHint', 'guifg=#2e2f6b')
      vim.cmd.highlight('Pmenu', 'guibg=#e6e6f1')
      vim.cmd.highlight('StatusLine', 'guibg=#2e2f6b')
      vim.cmd.highlight('StatusLineNC', 'guifg=#2e2f6b')
      vim.cmd.highlight('Cursor', 'guifg=#2e2f6b')

      local util = require('util')
      util.set_term_color('brightGreen', '#c2d3c3')
      util.set_term_color('brightRed', '#d1c0c0')
    end,
  },
  {
    repo = 'nickburlett/vim-colors-stylus',
    name = 'vim-colors-stylus',
    config = function()
      vim.cmd.colorscheme('stylus')
      vim.cmd.highlight('Pmenu', 'guibg=#F1F1F1')

      local util = require('util')
      util.set_term_color('brightGreen', '#80d780')
      util.set_term_color('brightRed', '#f78080')
    end,
  },
  {
    repo = 'zefei/cake16',
    name = 'cake16',
    config = function()
      vim.cmd.colorscheme('cake16')

      local util = require('util')
      util.set_term_color('brightGreen', '#a2d3a3')
      util.set_term_color('brightRed', '#d1a0a0')
    end,
  },
  {
    repo = 'ajlende/atlas.vim',
    name = 'atlas',
    config = function()
      vim.cmd.colorscheme('nms')
      vim.cmd.highlight('Search', 'guibg=#c6c6bC')
    end,
  },
  {
    repo = 'daschw/leaf.nvim',
    name = 'leaf',
    config = function()
      vim.cmd.colorscheme('leaf')

      local sl = vim.api.nvim_get_hl(0, { name = 'StatusLineNc' })
      sl.fg = '#000000'
      vim.api.nvim_set_hl(0, 'StatusLineNc', sl)
    end,
  },
}

