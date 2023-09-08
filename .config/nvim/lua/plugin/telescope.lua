local keys = vim.tbl_map(function(def)
  return vim.tbl_extend('keep', {
    '<leader>t' .. def.suffix,
    def.func or function()
      require('telescope/builtin')[def.func_name](def.arg)
    end,
  }, def.opt)
end, {
  {
    suffix = 'k',
    func_name = 'keymaps',
    opt = { desc = 'キーマップ' },
  },
  {
    suffix = 'g',
    func_name = 'live_grep',
    opt = { desc = 'grep' },
  },
  {
    suffix = 'h',
    func_name = 'help_tags',
    opt = { desc = 'ヘルプ' },
  },
  {
    suffix = 'c',
    func_name = 'commands',
    opt = { desc = 'コマンド' },
  },
  {
    suffix = 'o',
    func_name = 'find_files',
    opt = { desc = 'ファイル' },
    arg = {
      hidden = true,
    },
  },
  {
    suffix = 'b',
    func_name = 'buffers',
    opt = { desc = 'バッファ' },
    arg = {
      hidden = true,
      sort_mru = true,
    },
  },
  {
    suffix = 'd',
    func_name = 'diagnostics',
    opt = { desc = '診断' },
    arg = {
      severity = vim.diagnostic.severity.ERROR,
    },
  },
  {
    suffix = 'C',
    func_name = 'command_history',
    opt = { desc = 'コマンド履歴' },
  },
  {
    suffix = 'lr',
    func_name = 'lsp_references',
    opt = { desc = 'LSP-参照' },
  },
  {
    suffix = 'li',
    func_name = 'lsp_implementations',
    opt = { desc = 'LSP-実装' },
  },
  {
    suffix = 'lc',
    func_name = 'lsp_incoming_calls',
    opt = { desc = 'LSP-呼び出し元' },
  },
  {
    suffix = 'Gf',
    func_name = 'git_files',
    opt = { desc = 'git-ファイル' },
  },
  {
    suffix = 'Gc',
    func_name = 'git_commits',
    opt = { desc = 'git-コミット' },
  },
  {
    suffix = 'Gbc',
    func_name = 'git_bcommits',
    opt = { desc = 'git-バッファコミット' },
  },
  {
    suffix = 'Grc',
    func_name = 'git_bcommits_range',
    opt = { desc = 'git-範囲コミット', mode = 'x' },
  },
  {
    suffix = 'Gh',
    func_name = 'git_branches',
    opt = { desc = 'git-ブランチ' },
  },
  {
    suffix = 'Gs',
    func_name = 'git_status',
    opt = { desc = 'git-ステータス' },
  },
  {
    suffix = 'G/',
    func_name = 'git_stash',
    opt = { desc = 'git-スタッシュ' },
  },
})

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('util/init').reg_commands(require('telescope/builtin'), 'telescope')

    local actions = require('telescope/actions')
    require('telescope').setup({
      defaults = {
        path_display = { 'smart' },
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.95 },
        mappings = {
          i = {
            ['<C-s>'] = actions.cycle_previewers_next,
            ['<C-a>'] = actions.cycle_previewers_prev,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            n = {
              ['<M-d>'] = actions.delete_buffer,
            },
            i = {
              ['<M-d>'] = actions.delete_buffer,
            },
          },
        },
      },
    })
  end,
  keys = keys,
}
