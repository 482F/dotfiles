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
    suffix = 'H',
    func_name = 'oldfiles',
    opt = { desc = '過去のファイル' },
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
    suffix = 'O',
    func_name = 'find_files',
    opt = { desc = 'ファイル (.gitignore 参照なし)' },
    arg = {
      no_ignore = true,
    },
  },
  {
    suffix = '/',
    func_name = 'current_buffer_fuzzy_find',
    opt = { desc = '現在のバッファ内' },
    arg = { skip_empty_lines = true },
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
    suffix = 'D',
    func_name = 'diagnostics',
    opt = { desc = '診断 (警告などを含む)' },
  },
  {
    suffix = 'C',
    func_name = 'command_history',
    opt = { desc = 'コマンド履歴' },
  },
  {
    suffix = 'q',
    func_name = 'quickfix',
    opt = { desc = 'quickfix' },
  },
  {
    suffix = 'Q',
    func_name = 'quickfixhistory',
    opt = { desc = 'quickfix 履歴' },
  },
  {
    suffix = 'r',
    func_name = 'resume',
    opt = { desc = '前回の telescope を開く' },
  },
  {
    suffix = 't',
    func_name = 'filetypes',
    opt = { desc = 'filetypes' },
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
    local util = require('util/init')
    util.reg_commands(require('telescope/builtin'), 'telescope')

    local actions = require('telescope/actions')
    require('telescope').setup({
      defaults = {
        wrap_results = true,
        file_ignore_patterns = { '^%.git/[^ch].+$' }, -- .git/config と .git/hooks は見れるようにしたいが、先読みとかがないので頭文字だけで判定する
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.95 },
        mappings = {
          i = {
            ['<C-s>'] = actions.cycle_previewers_next,
            ['<C-a>'] = actions.cycle_previewers_prev,
            ['<M-q>'] = actions.add_selected_to_qflist,
            ['<C-q>'] = actions.send_selected_to_qflist,
            ['<C-Space>'] = actions.to_fuzzy_refine,
          },
        },
      },
      pickers = {
        quickfix = {
          mappings = {
            i = {
              ['<M-d>'] = function(prompt_bufnr)
                local state = require('telescope/actions.state')
                local current_picker = state.get_current_picker(prompt_bufnr)
                current_picker:delete_selection(function(entry)
                  util.remove_quickfix_by_bufnr_and_lnum(entry.bufnr, entry.lnum)
                end)
              end,
            },
          },
        },
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
