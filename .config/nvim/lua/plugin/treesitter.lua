return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = 'VeryLazy',
  config = function()
    local stream = require('util/stream')
    local ts = require('nvim-treesitter')

    vim.treesitter.start = (function(original)
      return function(...)
        pcall(original, ...)
      end
    end)(vim.treesitter.start)

    local installed_map = stream
      .start(ts.get_installed())
      .map(function(lang)
        return { lang, true }
      end)
      .from_pairs()
      .terminate()
    local function install(langs)
      langs = stream.filter(langs, function(lang)
        return not installed_map[lang]
      end)
      if #langs <= 0 then
        return
      end
      ts.install(langs, { force = false, summary = true }):wait(300000)
      stream.for_each(langs, function(lang)
        installed_map[lang] = true
      end)
      return langs
    end
    install({
      'javascript',
      'typescript',
      'vue',
      'lua',
      'diff',
      'git_rebase',
      'gitcommit',
      'nix',
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('vim-treesitter-start', {}),
      callback = function()
        local succ, parser = pcall(vim.treesitter.get_parser, 0)
        if not succ then
          return
        end
        local query = parser._injection_query
        local langs = stream
          .start(query and query.info.patterns or {})
          .flatten()
          .map(function(pattern)
            if pattern[2] == 'injection.language' then
              return pattern[3]
            end
            return nil
          end)
          .filter(function(lang)
            return lang ~= nil
          end)
          .inserted_all({ parser:lang() })
          .uniquify()
          .terminate()

        local installed = install(langs)
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
      end,
    })

    -- treesitter の diff ハイライトに対応していないカラースキームが多いのでそれの対応
    vim.cmd.highlight('def', 'link', '@text.diff.add', 'DiffAdded')
    vim.cmd.highlight('def', 'link', '@text.diff.delete', 'DiffRemoved')
  end,
}
