local stream = require('util/stream')
local keys = stream.map({
  { suffix = 'd', func_name = 'peek_definition' },
  { suffix = 'oo', func_name = 'open_in_original_window' },
  { suffix = 'ot', func_name = 'open_in_tab' },
  { suffix = 'm', func_name = 'peek_mark' },
  { suffix = 'r', func_name = 'restore_popup' },
  { suffix = 'R', func_name = 'restore_all_popups' },
  { suffix = 's', func_name = 'switch_focus' },
  { suffix = 'c', func_name = 'close_all' },
}, function(e)
  return {
    '<leader>lp' .. e.suffix,
    function()
      return require('overlook.api')[e.func_name]()
    end,
    desc = e.func_name,
  }
end)
return {
  'WilliamHsieh/overlook.nvim',
  keys = keys,
  config = function()
    require('overlook').setup({
      ui = {
        keys = {
          close = 'q',
        },
      },
    })
  end,
}
