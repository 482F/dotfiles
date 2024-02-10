local function delete_tele_buffer(prompt_bufnr)
  local action_state = require('telescope/actions/state')
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:delete_selection(function(selection)
    local force = vim.api.nvim_buf_get_option(selection.bufnr, 'buftype') == 'terminal'
    return pcall(require('util/init').bd, false, force, false, selection.bufnr)
  end)
end

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
    arg = {
      show_line = false,
    },
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
    suffix = '@',
    func = function()
      local conf = require('telescope.config').values
      local make_entry = require('telescope.make_entry')
      local finders = require('telescope.finders')
      local pickers = require('telescope.pickers')
      local opts = {}

      local bufnrs = vim.tbl_filter(function(bufnr)
        return vim.api.nvim_buf_get_option(bufnr, 'buftype') == 'terminal'
      end, vim.api.nvim_list_bufs())

      if not next(bufnrs) then
        return
      end

      local buffers = vim.tbl_map(function(bufnr)
        return {
          bufnr = bufnr,
          flag = ' ',
          info = vim.fn.getbufinfo(bufnr)[1],
        }
      end, bufnrs)
      local default_selection_idx = 1

      local max_bufnr = math.max(unpack(bufnrs))
      opts.bufnr_width = #tostring(max_bufnr)

      pickers
        .new(opts, {
          prompt_title = 'Terminal Buffers',
          finder = finders.new_table({
            results = buffers,
            entry_maker = make_entry.gen_from_buffer(opts),
          }),
          previewer = conf.grep_previewer(opts),
          sorter = conf.generic_sorter(opts),
          default_selection_index = default_selection_idx,
          attach_mappings = function(_, map)
            map({ 'i', 'n' }, '<M-d>', delete_tele_buffer)

            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            local action_set = require('telescope.actions.set')
            actions.select_default:replace(function(bufnr)
              local result = action_set.select(bufnr, 'default')
              local entry = action_state.get_selected_entry()
              if not entry then
                return
              end
              vim.bo[entry.bufnr].buflisted = false
              return result
            end)
            return true
          end,
        })
        :find()
    end,
    opt = { desc = 'terminal バッファ' },
  },
  {
    suffix = 'lr',
    func_name = 'lsp_references',
    opt = { desc = 'LSP-参照' },
    arg = {
      show_line = false,
    },
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
    suffix = 'ld',
    func_name = 'lsp_definitions',
    opt = { desc = 'LSP-定義' },
  },
  {
    suffix = 'lt',
    func_name = 'lsp_type_definitions',
    opt = { desc = 'LSP-型定義' },
  },
  {
    suffix = 'Gf',
    func = function()
      require('telescope/builtin').git_files({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-ファイル' },
  },
  {
    suffix = 'Gc',
    func = function()
      require('telescope/builtin').git_commits({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-コミット' },
  },
  {
    suffix = 'Gbc',
    func = function()
      require('telescope/builtin').git_bcommits({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-バッファコミット' },
  },
  {
    suffix = 'Grc',
    func = function()
      require('telescope/builtin').git_bcommits_range({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-範囲コミット', mode = 'x' },
  },
  {
    suffix = 'Gh',
    func = function()
      require('telescope/builtin').git_branches({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-ブランチ' },
  },
  {
    suffix = 'Gs',
    func = function()
      require('telescope/builtin').git_status({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
    opt = { desc = 'git-ステータス' },
  },
  {
    suffix = 'G/',
    func = function()
      require('telescope/builtin').git_stash({
        cwd = vim.fn.expand('%:p:h'),
      })
    end,
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
              ['<M-d>'] = delete_tele_buffer,
            },
            i = {
              ['<M-d>'] = delete_tele_buffer,
            },
          },
        },
      },
    })
  end,
  keys = keys,
}
