lua << EOF
  vim.cmd.source(vim.fn.resolve(vim.v.progpath .. '\\..\\..\\share\\nvim-qt\\runtime\\plugin\\nvim_gui_shim.vim'))
  vim.cmd.GuiFont('Cica:h13')
  vim.cmd.GuiTabline(0)
  vim.cmd.GuiPopupmenu(0)
  vim.cmd.GuiScrollBar(0)
EOF
