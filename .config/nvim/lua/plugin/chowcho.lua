return {
  'tkmpypy/chowcho.nvim',
  keys = {
    {
      '<C-w>w',
      function()
        require('chowcho').run()
      end,
    },
  },
  config = function()
    require('chowcho').setup({
      icon_enabled = false, -- required 'nvim-web-devicons' (default: false)
      text_color = '#FFFFFF',
      bg_color = '#555555',
      active_border_color = '#0A8BFF',
      border_style = 'default', -- 'default', 'rounded',
      use_exclude_default = false,
      zindex = 10000, -- sufficiently large value to show on top of the other windows
    })
  end,
}
