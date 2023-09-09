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
    arg = {
      git_command = {
        'git',
        'log',
        '--date=short',
        '--pretty=format:%h %ad[%an]:%B',
        '--abbrev-commit',
        '--',
        '.',
      },
    },
    opt = { desc = 'git-コミット' },
  },
  {
    suffix = 'Gbc',
    func = function()
      require('telescope/builtin').git_bcommits({
        git_command = {
          'git',
          'log',
          '--pretty=format:%h %ad[%an]:%B',
          '--date=short',
          '--abbrev-commit',
          '--follow',
        },
      })
    end,
    opt = { desc = 'git-バッファコミット' },
  },
  {
    suffix = 'Grc',
    func_name = 'git_bcommits_range',
    arg = {
      git_command = {
        'git',
        'log',
        '--date=short',
        '--pretty=format:%h %ad[%an]:%B',
        '--abbrev-commit',
        '--no-patch',
        '-L',
      },
    },
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
    require('telescope').setup({
      defaults = {
        path_display = { 'smart' },
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.95 },
      },
      pickers = {
        buffers = {
          mappings = {
            n = {
              ['<M-d>'] = require('telescope.actions').delete_buffer,
            },
            i = {
              ['<M-d>'] = require('telescope.actions').delete_buffer,
            },
          },
        },
      },
    })
  end,
  keys = keys,
}
