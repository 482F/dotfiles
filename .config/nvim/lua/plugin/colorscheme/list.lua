-- nix p shell gettext --command msgcat --color=test
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
  { repo = 'iibe/gruvbox-high-contrast', name = 'gruvbox-high-contrast' },
  { repo = 'jascha030/nitepal.nvim', name = 'nitepal' },
  { repo = 'elytraflyer/marsh.vim', name = 'marsh' },
  { repo = 'razcoen/fleet.nvim', name = 'fleet' },
  {
    repo = 'BoHomola/vsassist.nvim',
    name = 'vsassist',
    config = function()
      vim.api.nvim_set_hl(0, 'Cursor', {
        bg = '#d6d6d6',
      })
    end,
  },
  {
    repo = 'talha-akram/noctis.nvim',
    names = { 'noctis_lilac', 'noctis_lux' },
    config = function()
      vim.api.nvim_set_hl(0, 'Search', {
        bg = '#6972a8',
        fg = '#ffffff',
      })
      vim.api.nvim_set_hl(0, 'CurSearch', {
        bg = '#9972a8',
        fg = '#ffffff',
      })
    end,
  },
  {
    repo = 'Ureakim/nebulae.nvim',
    name = 'nebulae',
    config = function()
      local util = require('util')
      util.set_term_color('white', '#fcfcfc')
    end,
  },
  { repo = 'HUAHUAI23/nvim-quietlight', name = 'quietlight' },
  { repo = 'calind/selenized.nvim', name = 'selenized' },
  { repo = 'mstcl/dmg', name = 'dmg' },
  { repo = 'ribru17/bamboo.nvim', name = 'bamboo' },
  { repo = 'perpetuatheme/nvim', name = 'perpetua-light' },
  { repo = 'deparr/tairiki.nvim', name = 'tairiki' },
  {
    repo = 'itsterm1n4l/spice.nvim',
    name = 'spice',
    config = function()
      vim.api.nvim_set_hl(0, 'MiniStatuslineFileName', {
        bg = '#6972a8',
        fg = '#ffffff',
      })
    end,
  },
  { repo = 'binhtran432k/dracula.nvim', name = 'dracula' },
  { repo = 'zortax/three-firewatch', name = 'three-firewatch' },
  {
    repo = 'kordyte/collaterlie-nvim',
    name = 'collaterlie',
    config = function()
      local util = require('util')
      local stream = require('util/stream')
      local colors = util.get_term_colors()

      stream.for_each({ 'brightGreen', 'brightRed', 'yellow' }, function(name)
        util.set_term_color(name, util.mult_color(colors[name], 0.85))
      end)
      vim.api.nvim_set_hl(0, '@markup.raw', {
        fg = '#f19901',
      })
      vim.api.nvim_set_hl(0, '@markup.raw.block', {
        link = '@markup.raw',
      })
      vim.api.nvim_set_hl(0, 'EndOfBuffer', {
        link = 'Normal',
      })
    end,
  },
  { repo = 'habamax/vim-nod', name = 'nope-y' },
  { repo = 'futsuuu/vim-robot', name = 'robot' },
  { repo = 'clearaspect/onehalf', name = 'onehalflight' },
  {
    repo = 'fnune/standard',
    name = 'standard',
    config = function()
      vim.api.nvim_set_hl(0, 'GitConflictIncoming', {
        bg = '#c5d98b',
      })
      vim.api.nvim_set_hl(0, '@lsp.type.property', {
        fg = '#616466',
      })
      vim.api.nvim_set_hl(0, '@lsp.typemod.property', {
        link = '@lsp.type.property',
      })
      vim.api.nvim_set_hl(0, '@variable.member', {
        link = '@lsp.type.property',
      })
    end,
  },
  { repo = 'isrothy/nordify.nvim', name = 'nordify-light' },
  { repo = 'ricardoraposo/nightwolf.nvim', name = 'nightwolf' },
  { repo = 'ferdinandrau/carbide.nvim', name = 'carbide' },
  {
    repo = 'oonamo/ef-themes.nvim',
    names = { 'ef-duo-light', 'ef-reverie', 'ef-spring', 'ef-kassio', 'ef-cyprus', 'ef-eagle', 'ef-day' },
    config = function()
      local util = require('util')
      util.set_term_color('green', '#217a3c')
    end,
  },
  { repo = 'titembaatar/sarnai.nvim', name = 'sarnai-ovol' },
  { repo = 'tiesen243/vercel.nvim', name = 'vercel' },
  { repo = 'cpplain/flexoki.nvim', name = 'flexoki' },
  { repo = 'webhooked/kanso.nvim', name = 'kanso' },
  { repo = 'khoido2003/classic_monokai.nvim', name = 'classic-monokai' },
  {
    repo = 'liuchengxu/space-vim-theme',
    name = 'space_vim_theme',
    config = function()
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
      require('everforest').setup({
        background = 'hard',
      })
    end,
  },
  {
    repo = 'catppuccin/nvim',
    name = 'catppuccin-latte',
  },
  {
    repo = 'FrenzyExists/aquarium-vim',
    name = 'aquarium',
    config = function()
      vim.cmd.highlight('Comment', 'guifg=#9CA6B9')
      vim.cmd.highlight('DiagnosticHint', 'guifg=#2e2f6b')
      vim.cmd.highlight('Pmenu', 'guibg=#e6e6f1')
      vim.cmd.highlight('StatusLine', 'guibg=#2e2f6b')
      vim.cmd.highlight('StatusLineNC', 'guifg=#2e2f6b')
      vim.cmd.highlight('Cursor', 'guifg=#2e2f6b')

      local util = require('util')
      util.set_term_color('brightGreen', '#c2d3c3')
      util.set_term_color('brightRed', '#d1c0c0')
      vim.api.nvim_set_hl(0, 'GitConflictCurrent', {
        bg = '#d1c0c0',
      })
      vim.api.nvim_set_hl(0, 'GitConflictAncestor', {
        bg = '#c6c6d1',
      })
      vim.api.nvim_set_hl(0, 'GitConflictIncoming', {
        bg = '#c2d3c3',
      })
    end,
  },
  {
    repo = 'nickburlett/vim-colors-stylus',
    name = 'stylus',
    config = function()
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
      local util = require('util')
      util.set_term_color('brightGreen', '#a2d3a3')
      util.set_term_color('brightRed', '#d1a0a0')
    end,
  },
  {
    repo = 'ajlende/atlas.vim',
    name = 'nms',
    config = function()
      vim.cmd.highlight('Search', 'guibg=#c6c6bC')
    end,
  },
  {
    repo = 'daschw/leaf.nvim',
    name = 'leaf',
    config = function()
      local sl = vim.api.nvim_get_hl(0, { name = 'StatusLineNc' })
      sl.fg = '#000000'
      vim.api.nvim_set_hl(0, 'StatusLineNc', sl)
    end,
  },
  {
    repo = 'wesenseged/stone.nvim',
    name = 'stone',
    config = function()
      require('stone').setup({
        variant = 'light',
      })
    end,
  },
  {
    repo = 'gambhirsharma/vesper.nvim',
    name = 'vesper',
    config = function()
      vim.cmd.highlight('Visual', 'guibg=#c6c6c6')
    end,
  },
}
