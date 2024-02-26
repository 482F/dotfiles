-- eclipse.jdtls.ls を .local/share/ 下にインストール
-- .local/share/jdtls/ 下に lombok.jar (https://projectlombok.org/downloads/lombok.jar) を配置
-- フォーマッタの設定を /home/normal/.local/share/jdtls/format-settings.xml に配置
-- 各プロジェクトで `mvn clean & mvn install`
-- microsoft/java-debug を /home/normal/.local/share/jdtls/java-debug にクローン
local function parse_url(url)
  for ip, port in string.gmatch(url, 'https?://([^:]+):(%d+)$') do
    return ip, port
  end
end
return {
  'mfussenegger/nvim-jdtls',
  ft = 'java',
  keys = {
    {
      '<leader>po',
      function()
        require('jdtls').organize_import()
      end,
      desc = 'インポート整理',
    },
  },
  config = function()
    local fu = require('util/func')
    local stream = require('util/stream')

    local cmd = {
      '/usr/lib/jvm/java-17-openjdk-amd64/bin/java',

      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',

      '-javaagent:/home/normal/.local/share/jdtls/lombok.jar',

      '-jar',
      '/home/normal/.local/share/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar',
      '-configuration',
      '/home/normal/.local/share/jdtls/config_linux',

      '-data',
      '/home/normal/.local/share/nvim-jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t'),
    }
    stream.for_each({ 'http', 'https' }, function(_, protocol)
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
    local config = {
      cmd = cmd,
      root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
      settings = {
        java = {
          format = {
            settings = {
              url = '/home/normal/.local/share/jdtls/format-settings.xml',
            },
          },
        },
      },
      init_options = {
        bundles = {
          '/home/normal/.local/share/jdtls/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.48.0.jar',
        },
      },
    }
    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = 'java',
      callback = function()
        require('jdtls').start_or_attach(config)
      end,
    })
    local jdtls_util = require('jdtls.util')
    local original_execute_command = jdtls_util.execute_command
    jdtls_util.execute_command = function(opt, callback, ...)
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

      original_execute_command(opt, callback, ...)
    end

    local util = require('util')
    util.reg_commands(require('jdtls'), 'jdtls')
  end,
}
