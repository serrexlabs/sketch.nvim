local M = {}

M.run_code = function(options)
  local command_options = require("sketch.nvim.command")
  local filetype = vim.bo.filetype
  local strategy = require("sketch.nvim.strategies")
  local current_buffer_path = vim.fn.expand('%:p')


  local executables = options.executables[filetype]
  if executables == nil then
    vim.api.nvim_err_write("The filetype " ..
      filetype .. " hasn't been configured with an executable in the setup options.\n")
    return
  end

  local command = command_options.get_executable_command(executables, current_buffer_path)
  if command == nil then
    vim.api.nvim_err_write("The executable (" ..
      executables .. ") not found in your system for the filetype " .. filetype .. "\n")
    return
  end

  vim.cmd("noa silent w")

  strategy.execute(command, options)
end

return M

