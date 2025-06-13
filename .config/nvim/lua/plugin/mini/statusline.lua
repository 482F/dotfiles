local status = {
  colorscheme = vim.g.colors_name,
}
local function update_colorscheme()
  status.colorscheme = vim.g.colors_name
end

-- ステータスライン
local mini_statusline = require('mini.statusline')
mini_statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
      local filename = mini_statusline.section_filename({ trunc_width = 140 })
      local fileinfo = mini_statusline.section_fileinfo({ trunc_width = 120 })
      local location = mini_statusline.section_location({ trunc_width = 75 })

      return mini_statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineDevinfo', strings = { status.colorscheme } },
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { location } },
      })
    end,
  },
  use_icons = false,
  set_vim_settings = false,
})

vim.wo.statusline = '%!v:lua.MiniStatusline.active()'

return {
  update_colorscheme = update_colorscheme,
}
