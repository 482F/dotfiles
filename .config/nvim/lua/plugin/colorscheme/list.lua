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
  {
    repo = 'jascha030/nitepal.nvim',
    name = 'nitepal',
    config = function()
      local stream = require('util/stream')

      return stream.for_each({
        DiagnosticVirtualTextError = {
          bg = '#f2b5dd',
          fg = '#870743',
        },
        DiagnosticVirtualTextWarn = {
          bg = '#ffdfb9',
          fg = '#b17500',
        },
        DiagnosticVirtualTextInfo = {
          bg = '#b0ddf5',
          fg = '#054d5b',
        },
        DiagnosticVirtualTextHint = {
          bg = '#beffdc',
          fg = '#0e816a',
        },
      }, function(color, name)
        vim.api.nvim_set_hl(0, name, color)
      end)
    end,
  },
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
      util.set_term_color('black', '#000000')

      vim.api.nvim_set_hl(0, 'Search', {
        bg = '#f6d692',
        fg = '#ffffff',
      })
    end,
  },
  {
    repo = 'HUAHUAI23/nvim-quietlight',
    name = 'quietlight',
    config = function()
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', {
        fg = '#f5f5f5',
        bg = '#705697',
      })

      local util = require('util')
      util.set_term_color('brightGreen', '#c4d7d7')
      util.set_term_color('brightRed', '#f4b7d7')
    end,
  },
  { repo = 'calind/selenized.nvim', name = 'selenized' },
  {
    repo = 'mstcl/dmg',
    name = 'dmg',
    config = function()
      local util = require('util')
      local stream = require('util/stream')
      stream.for_each({
        black = '#c8beb7',
        blue = '#26126d',
        brightBlack = '#bdb1a8',
        brightBlue = '#483d8b',
        brightCyan = '#88addb',
        brightGreen = '#24752d',
        brightPurple = '#72347c',
        brightRed = '#752c5f',
        brightWhite = '#2c2621',
        brightYellow = '#e4d54d',
        cyan = '#488d9b',
        green = '#184e1e',
        purple = '#793454',
        red = '#630e49',
        white = '#161e29',
        yellow = '#c4b52d',
      }, function(col, name)
        util.set_term_color(name, col)
      end)
    end,
  },
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
      vim.api.nvim_set_hl(0, 'Search', {
        bg = '#2e7de9',
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
  {
    repo = 'ferdinandrau/carbide.nvim',
    name = 'carbide',
    config = function()
      local util = require('util')
      util.set_term_color('black', '#000000')
    end,
  },
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
  { repo = 'webhooked/kanso.nvim', name = 'kanso-pearl' },
  { repo = 'khoido2003/classic_monokai.nvim', name = 'classic-monokai' },
  {
    repo = 'liuchengxu/space-vim-theme',
    name = 'space_vim_theme',
    config = function()
      vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#E5DCCE' })
      vim.api.nvim_set_hl(0, 'GitConflictCurrent', {
        bg = '#fbe6e6',
      })
      vim.api.nvim_set_hl(0, 'GitConflictAncestor', {
        bg = '#eeeefb',
      })
      vim.api.nvim_set_hl(0, 'GitConflictIncoming', {
        bg = '#e9fdea',
      })
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
      vim.api.nvim_set_hl(0, 'Visual', { bg = '#c6c6c6' })
      vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#c6c6c6' })
    end,
  },
  {
    repo = 'kuri-sun/yoda.nvim',
    name = 'yoda',
    config = function()
      require('yoda').setup({
        theme = 'light',
      })
    end,
  },
}
