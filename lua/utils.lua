local M = {}

-- Functions to save a file with sudo, stolen from github:ibhagwan/nvim-lua
M.sudo_exec = function(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    print("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    print(out)
    return false
  end
  if print_output then print("\r\n", out) end
  return true
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    print("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = true })
  if M.sudo_exec(cmd) then
    -- refreshes the buffer silently
    vim.cmd('edit!')
    -- exit command mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(
      "<Esc>", true, false, true), "n", true)
  else
    print("Failed to save file.")
    return false
  end
  vim.fn.delete(tmpfile)
  return true
end

M.sudo_write_quit = function(tmpfile, filepath)
  if M.sudo_write(tmpfile, filepath) then 
    vim.cmd.quit()
  end
end

-- from https://smarttech101.com/nvim-lsp-diagnostics-keybindings-signs-virtual-texts
M.print_diagnostics = function(opts, buf, line, client_id)
  buf = buf or 0
  line = line or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line}

  local severity_info = {
    [vim.diagnostic.severity.ERROR] = {"DiagnosticError", "E"},
    [vim.diagnostic.severity.WARN] = {"DiagnosticWarn", "W"},
    [vim.diagnostic.severity.INFO] = {"DiagnosticInfo", "I"},
    [vim.diagnostic.severity.HINT] = {"DiagnosticHint", "H"}
  }
  
  local line_diagnostics = vim.diagnostic.get(buf, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_messages = {}
  for _, diagnostic in ipairs(line_diagnostics) do
    local msg = string.format("[%s] %s\n", 
                                severity_info[diagnostic.severity][2], 
                                diagnostic.message or "")
    table.insert(diagnostic_messages, {msg, severity_info[diagnostic.severity][1]})
  end
  vim.api.nvim_echo(diagnostic_messages, false, {})
end

return M
