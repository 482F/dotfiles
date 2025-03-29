-- eclipse.jdtls.ls を $XDG_DATA_HOME 下にインストール
-- .local/share/jdtls/ 下に lombok.jar (https://projectlombok.org/downloads/lombok.jar) を配置
-- フォーマッタの設定を $XDG_DATA_HOME/jdtls/format-settings.xml に配置
-- 各プロジェクトで `mvn clean & mvn install`
-- microsoft/java-debug を $XDG_DATA_HOME/jdtls/java-debug にクローンし、`./mvnc clean install`
-- - できあがった com.microsoft.java.debug.plugin-*.jar を $XDG_DATA_HOME/jdtls/ 下に移動
local function parse_url(url)
  for ip, port in string.gmatch(url, 'https?://([^:]+):(%d+)$') do
    return ip, port
  end
end

local util = require('util')
local stream = require('util/stream')

return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  keys = stream
    .start({
      { key = 'oi', title = 'Organize imports' },
      { key = 'ev', title = 'Extract to local variable (replace all occurrences)' },
    })
    .map(function(def)
      return {
        '<leader>ll' .. def.key,
        function()
          util.exec_code_action(def.title)
        end,
        desc = def.title,
      }
    end)
    .inserted_all({
      {
        '<leader>po',
        function()
          require('jdtls').organize_import()
        end,
        desc = 'インポート整理',
      },
      {
        '<leader>pc',
        function()
          require('jdtls').update_projects_config({})
        end,
        desc = 'config 更新',
      },
    })
    .terminate(),
  config = function()
    local fu = require('util/func')

    local jdtls_dir = vim.env['XDG_DATA_HOME'] .. '/jdtls'

    local cmd = {
      'java17',

      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx2g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',

      '-javaagent:' .. jdtls_dir .. '/lombok.jar',

      '-jar',
      jdtls_dir .. '/plugins/org.eclipse.equinox.launcher.jar',
      '-configuration',
      jdtls_dir .. '/config_linux',

      '-data',
      vim.env['XDG_DATA_HOME'] .. '/nvim-jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
    }
    stream.for_each({ 'http', 'https' }, function(protocol)
      local proxy = vim.env[protocol .. '_proxy']
      if proxy == nil then
        return
      end
      local ip, port
      ip, port = parse_url(proxy)
      if ip ~= nil then
        table.insert(cmd, '-D' .. protocol .. '.proxyHost=' .. ip)
        table.insert(cmd, '-D' .. protocol .. '.proxyPort=' .. port)
      end
    end)
    local jdks = vim.env['XDG_DATA_HOME'] .. '/jdks'
    local runtimes = stream.map(vim.fn.readdir(jdks), function(name)
      return {
        name = name,
        path = jdks .. '/' .. name,
      }
    end)
    local config = {
      cmd = cmd,
      root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
      settings = {
        java = {
          configuration = {
            runtimes = runtimes,
          },
          completion = {
            maxResults = 5000,
          },
          format = {
            settings = {
              url = jdtls_dir .. '/format-settings.xml',
            },
          },
        },
      },
      init_options = {
        bundles = {
          jdtls_dir .. '/com.microsoft.java.debug.plugin.jar',
        },
      },
    }
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = 'java',
      callback = function()
        require('jdtls').start_or_attach(config)
      end,
    })

    fu.override(require('jdtls/util'), 'execute_command', function(original, opt, callback, ...)
      if opt ~= nil and opt.command == 'vscode.java.resolveMainClass' then
        local project_name_map = stream
          .start(vim.g.jdtls_project_names or {})
          .map(function(name)
            return { name, true }
          end)
          .from_pairs()
          .terminate()
        local original_callback = callback
        callback = function(err, mainclasses)
          original_callback(
            err,
            stream.filter(mainclasses, function(mc)
              return fu.is_truthy(project_name_map[mc.projectName])
            end)
          )
        end
      end

      original(opt, callback, ...)
    end)

    util.reg_commands(require('jdtls'), 'jdtls')
  end,
}
