vim.cmd [[
      aunmenu PopUp
      anoremenu PopUp.Inspect           <cmd>Inspect<CR>
      anoremenu PopUp.Serial_Monitor    <cmd>lua _G.serial_monitor()<CR>
      amenu PopUp.-1-                   <NOP>
      amenu PopUp.LSP:                  <NOP>
      anoremenu PopUp._Details           <cmd>lua vim.lsp.buf.hover()<CR>
      anoremenu PopUp._Definition        <cmd>lua vim.lsp.buf.definition()<CR>
      anoremenu PopUp._Implementation    <cmd>lua vim.lsp.buf.implementation()<CR>
      anoremenu PopUp._References        <cmd>Telescope lsp_references<CR>
      anoremenu PopUp._Format_Document   <cmd>lua vim.lsp.buf.format({ async = true })<CR>
      anoremenu PopUp._Code_Action       <cmd>lua vim.lsp.buf.code_action()<CR>
      amenu PopUp.-2-                   <NOP>
      nnoremenu PopUp.Back              <C-t>
    ]];

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
vim.api.nvim_create_autocmd("MenuPopup", {
  pattern = '*',
  group = group,
  desc = "Custom PopUp Setup",
  callback = function()
    vim.cmd [[
      amenu disable PopUp.-1-
      amenu disable PopUp.LSP:
      amenu disable PopUp._Details
      amenu disable PopUp._Definition
      amenu disable PopUp._Implementation
      amenu disable PopUp._References
      amenu disable PopUp._Format_Document
      amenu disable PopUp._Code_Action
      amenu disable PopUp.-2-
    ]]
    if vim.lsp.get_clients({ bufnr = 0 })[1] then
      vim.cmd [[
        amenu enable PopUp.-1-
        amenu enable PopUp.LSP:
        amenu enable PopUp._Details
        amenu enable PopUp._Definition
        amenu enable PopUp._Implementation
        amenu enable PopUp._References
        amenu enable PopUp._Format_Document
        amenu enable PopUp._Code_Action
        amenu enable PopUp.-2-
      ]]
    end
  end
})
