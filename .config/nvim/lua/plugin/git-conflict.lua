local keys = vim.tbl_map(function(t)
  return {
    '<leader>gc' .. t.key,
    t.func or function()
      vim.cmd[t.cmd]()
    end,
    desc = t.desc,
  }
end, {
  -- git ディレクトリ全てのコンフリクトの検出、ファイル感の移動ができなさそうなので、それらは qflist ですることにする
  -- { key = 'n', cmd = 'GitConflictNextConflict', desc = '次のコンフリクトへ移動' },
  -- { key = 'p', cmd = 'GitConflictPrevConflict', desc = '前のコンフリクトへ移動' },
  -- { key = 'r', cmd = 'GitConflictRefresh', desc = 'コンフリクトを再検出' },
  { key = 'o', cmd = 'GitConflictChooseOurs', desc = 'ours を選択' },
  { key = 't', cmd = 'GitConflictChooseTheirs', desc = 'theirs を選択' },
  { key = 'B', cmd = 'GitConflictChooseBoth', desc = '両方選択' },
  { key = '0', cmd = 'GitConflictChooseNone', desc = 'どちらも選択しない' },
  {
    key = 'q',
    func = function()
      vim.cmd.grep({ args = { '"^<<<<<<<"' }, mods = { silent = true }, bang = true })
      vim.cmd.redraw({ bang = true })
    end,
    desc = 'qflist に追加',
  },
})

local function set_bg(name, default_bg)
  if not name then
    return
  end
  local hl = vim.api.nvim_get_hl(0, { name = name })

  local bg = default_bg
  if hl.reverse then
    bg = bg or hl.fg or hl.foreground
  end
  bg = bg or hl.ctermbg

  hl.background = hl.background or bg
  vim.api.nvim_set_hl(0, name, hl)
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    set_bg('DiffAdd', '#f3f5d9')
    set_bg('DiffDelete', '#ffe7de')
    set_bg('DiffChange', '#ecf5ed')
  end,
})

return {
  'akinsho/git-conflict.nvim',
  event = 'VeryLazy',
  keys = keys,
  config = function()
    -- 不要なパラメータまで必須になっているので黙らせる
    ---@diagnostic disable-next-line missing-fields
    require('git-conflict').setup({
      default_mappings = false, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      list_opener = 'copen', -- command or function to open the conflicts list
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = 'DiffAdd',
        current = 'DiffDelete',
        ancestor = 'DiffChange',
      },
    })
  end,
}
