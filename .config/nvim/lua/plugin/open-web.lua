return {
  '482F/telescope-open-web',
  dependencies = { 'kkharji/sqlite.lua' },
  -- dir = '/home/normal/git/telescope-open-web',
  name = 'open-web',
  branch = 'master',
  keys = {
    {
      '<leader>ts',
      function()
        require('telescope').extensions.open_web()
      end,
      desc = 'ブラウザを開く'
    },
  },
  config = function()
    local stream = require('util/stream')
    local plugins = stream
      .start(require('lazy').plugins())
      .map(function(plugin)
        return plugin[1]
      end)
      .filter(function(name)
        return name ~= nil
      end)
      .map(function(name)
        return {
          name = name,
          model = 'https://github.com/search?q=repo:' .. name .. '+${1}&type=code',
          top = 'https://github.com/' .. name,
          id = name,
        }
      end)
      .terminate()
    plugins.desc = 'search installed plugins'
    plugins.name = 'plugins'

    require('telescope').setup({
      extensions = {
        open_web = {
          provider = 'google',
          bookmarks = {
            {
              name = 'google',
              id = 'google',
              model = 'https://www.google.com/search?q=${1}',
              desc = 'search by google',
            },
            plugins,
            {
              name = 'mdn',
              id = 'mdn',
              desc = 'search in mdn',
              model = 'https://developer.mozilla.org/ja/search?q=${1}',
            },
          },
        },
      },
    })
    require('telescope').load_extension('open_web')
  end,
}
