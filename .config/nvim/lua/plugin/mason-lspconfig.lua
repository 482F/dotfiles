local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {})
local stream = require('util/stream')

local function on_list(result)
  vim.fn.setloclist(0, {}, ' ', result)
  if #result.items <= 1 then
    vim.cmd.lfirst()
  else
    require('telescope/builtin').loclist({ show_line = false })
  end
end

local diagnostics_mode = 0
local function toggle_diagnostics_mode()
  local modes = { 'virtual_text', 'virtual_lines' }
  diagnostics_mode = (diagnostics_mode % #modes) + 1
  vim.diagnostic.config(stream
    .start(modes)
    .map(function(key, i)
      return { key, diagnostics_mode == i }
    end)
    .from_pairs()
    .terminate())
end
toggle_diagnostics_mode()

local keys = stream.map({
  {
    suffix = 'c',
    func = function()
      vim.lsp.handlers['textDocument/hover'] = function(...)
        local h_bufnr, h_winid = hover_handler(...)
        vim.lsp.handlers['textDocument/hover'] = hover_handler

        local height
        if h_winid == nil then
          height = 0
        else
          height = vim.api.nvim_win_get_height(h_winid)
        end
        vim.api.nvim_buf_set_var(0, 'lsp_floating_preview', nil)
        local _, d_winnr = vim.diagnostic.open_float()
        if d_winnr == nil then
          return h_bufnr, h_winid
        end
        vim.api.nvim_win_set_config(d_winnr, {
          relative = 'cursor',
          row = height + 1,
          col = 0,
        })

        return h_bufnr, h_winid
      end
      vim.lsp.buf.hover()
    end,
    opt = { desc = '情報と診断を表示' },
  },
  {
    suffix = 'C',
    func = toggle_diagnostics_mode,
    opt = { silent = true, desc = '診断の表示方を切り替え' },
  },
  { suffix = 'fm', func = vim.cmd.Format, opt = { silent = true, desc = 'フォーマット' } },
  { suffix = 'h', func = vim.lsp.buf.hover, opt = { desc = '情報を表示' } },
  { suffix = 'H', func = vim.diagnostic.open_float, opt = { desc = '診断を表示' } },
  {
    suffix = 'r',
    func = function()
      vim.lsp.buf.references(nil, { on_list = on_list })
    end,
    opt = { desc = '参照に移動' },
  },
  {
    suffix = 'd',
    func = function()
      vim.lsp.buf.definition({ on_list = on_list })
    end,
    opt = { desc = '宣言に移動' },
  },
  {
    suffix = 'D',
    func = function()
      vim.lsp.buf.declaration({ on_list = on_list })
    end,
    opt = { desc = '定義に移動' },
  },
  {
    suffix = 'i',
    func = function()
      vim.lsp.buf.implementation({ on_list = on_list })
    end,
    opt = { desc = '実装に移動' },
  },
  {
    suffix = 't',
    func = function()
      vim.lsp.buf.type_definition({ on_list = on_list })
    end,
    opt = { desc = '型定義に移動' },
  },
  { suffix = 'R', func = vim.lsp.buf.rename, opt = { desc = 'リネーム' } },
  { suffix = 'a', func = vim.lsp.buf.code_action, opt = { desc = 'コードアクション' } },
}, function(def)
  local desc = def.opt.desc
  if desc ~= nil then
    desc = 'lsp-' .. desc
  end
  return stream.inserted_all(def.opt, {
    '<leader>l' .. def.suffix,
    def.func,
    desc = desc,
  })
end)

local function install()
  local fu = require('util/func')

  local tools = {
    {
      name = 'deno',
      filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    },
    {
      name = 'stylua',
      filetypes = { 'lua' },
    },
    {
      name = 'prettierd',
      filetypes = {
        'markdown',
        'javascript',
        'typescript',
        'json',
        'jsonc',
        'json5',
        'vue',
        'jsx',
        'tsx',
        'css',
        'scss',
        'html',
        'yaml',
      },
    },
    {
      name = 'lua-language-server',
      filetypes = { 'lua' },
    },
    {
      name = 'typescript-language-server',
      filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
    },
    {
      name = 'vue-language-server',
      filetypes = { 'vue' },
    },
    {
      name = 'python-lsp-server',
      filetypes = { 'python' },
    },
    {
      name = 'rust-analyzer',
      filetypes = { 'rust' },
    },
  }

  local need_to_install_tools = stream.filter(tools, function(tool)
    return not require('mason-registry').is_installed(tool.name) and not vim.fn.executable(tool.name)
  end)

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    callback = function(e)
      local filtered_need_to_install_tools = stream
        .start(need_to_install_tools)
        .filter(function(tool)
          return stream.includes(tool.filetypes, e.match)
        end)
        .map(fu.picker('name'))
        .terminate()
      if not stream.is_empty(filtered_need_to_install_tools) then
        require('mason/api/command').MasonInstall(filtered_need_to_install_tools)
      end
    end,
  })
end

local function config()
  local specials = {
    'denols',
    'vtsls',
  }
  local lsps = {
    'lua_ls',
    'vue_ls',
    'pylsp',
    'rust_analyzer',
  }

  stream
    .start(lsps)
    .inserted_all(specials)
    .map(function(name)
      return { name, require('plugin/lsp/' .. name) }
    end)
    .from_pairs()
    .for_each(function(func, key)
      vim.lsp.config(key, func())
    end)
  vim.lsp.enable(lsps)

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(ctx)
      local is_compatible = stream.map({ denols = false, vtsls = false }, function(_, name)
        return vim.tbl_contains(vim.lsp.config[name].filetypes, ctx.match)
      end)

      if not is_compatible.denols and not is_compatible.vtsls then
        return
      end

      local target_name = nil
      if is_compatible.denols then
        target_name = 'denols'
      end
      if is_compatible.vtsls then
        target_name = 'vtsls'
      end

      if is_compatible.denols and is_compatible.vtsls then
        local has_deno_json = stream
          .start({ 'deno.json', 'deno.jsonc' })
          .map(function(name)
            return vim.fn.findfile(name, '.;')
          end)
          .find(function(v)
            return v ~= ''
          end) ~= nil

        if has_deno_json then
          target_name = 'denols'
        else
          target_name = 'vtsls'
        end
      end
      vim.lsp.start(vim.lsp.config[target_name])
    end,
  })
end

local ft2ext_map = {
  javascript = 'js',
  typescript = 'ts',
  markdown = 'md',
}

local get_file_path = function()
  local path = require('formatter/util').get_current_buffer_file_path()
  if path == '' then
    path = vim.fn.getcwd() .. '/'
  end
  local ext = ft2ext_map[vim.bo.filetype] or vim.bo.filetype
  if path:find('%.' .. ext .. '$') then
    return path
  end
  local name = vim.fn.expand('%:t')
  if name == '' then
    name = 'temp'
  end
  return path .. name .. '.' .. ext
end

local function formatter()
  local filetypes = {}
  filetypes = stream.from_pairs(stream.flat_map({
    {
      filetypes = { 'nix' },
      data = { require('formatter/filetypes/nix').alejandra },
    },
    {
      filetypes = { 'lua' },
      data = { require('formatter/filetypes/lua').stylua },
    },
    {
      filetypes = { 'rust' },
      data = { require('formatter/filetypes/rust').rustfmt },
    },
    {
      filetypes = { 'sql' },
      data = { require('formatter/filetypes/sql').pgformat },
    },
    {
      filetypes = { 'markdown' },
      data = {
        function()
          return {
            exe = 'prettier',
            args = {
              '--tab-width',
              '4',
              '--stdin-filepath',
              require('formatter/util').escape_path(get_file_path()),
              '--parser',
              'markdown',
            },
            stdin = true,
            try_node_modules = false,
          }
        end,
      },
    },
    {
      filetypes = {
        'javascript',
        'typescript',
        'vue',
        'jsx',
        'tsx',
        'css',
        'scss',
        'html',
        'json',
        'jsonc',
        'json5',
        'yaml',
      },
      data = {
        function(...)
          local has_deno_json = stream
            .start({ 'deno.json', 'deno.jsonc' })
            .map(function(name)
              return vim.fn.findfile(name, '.;')
            end)
            .find(function(v)
              return v ~= ''
            end) ~= nil
          local is_json = vim.bo.filetype:find('json', 0, true) ~= nil
          if has_deno_json and not is_json then
            -- 引数が追加されるかもしれないので受け取ったものをそのまま渡す
            ---@diagnostic disable-next-line: redundant-parameter
            return require('formatter/defaults/denofmt')(...)
          else
            return stream.inserted_all(require('formatter/defaults/prettier')(...), { try_node_modules = false }, 0)
          end
        end,
      },
    },
    {
      filetypes = { 'python' },
      data = { require('formatter/filetypes/python').autopep8 },
    },
    {
      filetypes = { '*' },
      data = {
        function()
          if filetypes[vim.bo.filetype] ~= nil then
            return
          end
          vim.lsp.buf.format({ timeout_ms = 10000000 })
        end,
      },
    },
  }, function(v)
    return stream.map(v.filetypes, function(filetype)
      return { filetype, v.data }
    end)
  end))

  require('formatter').setup({
    filetype = filetypes,
  })
end

local function linter()
  local util = require('util')

  local linters_by_ft = {
    java = { 'checkstyle' },
  }
  require('lint.linters.checkstyle').config_file = vim.env['XDG_DATA_HOME'] .. '/checkstyle.xml'
  require('lint.linters.checkstyle').cmd = 'checkstyle-stdin'
  require('lint.linters.checkstyle').stdin = true
  table.insert(require('lint.linters.checkstyle').args, function()
    return vim.api.nvim_buf_get_name(0)
  end)
  require('lint.linters.checkstyle').append_fname = true

  local cwd = vim.loop.cwd()
  local deno_jsonc_exists = cwd
    and stream.some(util.ancestor_dirs(cwd), function(dir)
      return util.file_exists(dir .. 'deno.jsonc')
    end)
  require('lint.linters.eslint').cmd = 'eslint'
  if not deno_jsonc_exists then
    linters_by_ft.typescript = { 'eslint' }
    linters_by_ft.javascript = { 'eslint' }
    linters_by_ft.vue = { 'eslint' }
  end

  require('lint').linters_by_ft = linters_by_ft
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'BufReadPost' }, {
    callback = function()
      require('lint').try_lint()
    end,
  })
end

return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'mason-org/mason-registry',
    'rcarriga/nvim-notify',
    'mhartington/formatter.nvim',
    'mfussenegger/nvim-lint',
  },
  event = 'VeryLazy',
  keys = keys,
  config = function()
    install()
    config()
    formatter()
    linter()
  end,
}
