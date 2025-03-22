return {
  'matsui54/denops-signature_help',
  event = 'VeryLazy',
  config = function()
    vim.g.signature_help_config = {
      viewStyle = 'ghost',
    }
    vim.fn['signature_help#enable']()
  end,
}
