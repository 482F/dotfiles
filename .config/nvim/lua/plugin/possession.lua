return {
  'jedrzejboczar/possession.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('possession').setup({
      session_dir = vim.fn.stdpath('data') .. 'possession',
    })

    local function get_cwd_name()
      local cwdName = string.gsub(vim.fn.getcwd(), '/', '--')
      return cwdName
    end

    local commands = require('util/init').reg_commands({
      saveCwd = function(noConfirm)
        if noConfirm == nil then
          noConfirm = true
        end
        require('possession.session').save(get_cwd_name(), { no_confirm = noConfirm })
      end,
      loadCwd = function()
        local cwd = get_cwd_name()
        if not require('possession.session').exists(cwd) then
          return
        end
        require('possession.session').load(cwd)
      end,
    })

    vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
      callback = function()
        commands.saveCwd(false)
      end,
    })

    vim.api.nvim_create_autocmd({ 'VimEnter' }, {
      nested = true, -- autocmd 内での動作によって autocmd を発火させるために必要。これがないとファイルタイプの判定とかが行われなくなる
      callback = function()
        local confirmed = string.upper(vim.fn.input({ prompt = 'load profile?[Y/n]: ' }))
        if confirmed ~= 'Y' and confirmed ~= '' then
          return
        end
        commands.loadCwd()
      end,
    })
  end,
}
