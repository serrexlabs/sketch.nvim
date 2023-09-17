local M = {}

-- Neovim Terminal
local term = function(command)
  local terminal_height = vim.o.lines * 0.2

  vim.cmd('split')
  vim.cmd('resize ' .. terminal_height)
  vim.cmd('terminal ' .. command)
end

-- Dispatch.vim or Asynchronous Method (Modify as needed)
local dispatch = function(command)
  vim.cmd("Dispatch " .. command)
end

M.execute = function(command, options)
  local stratergy = options.strategy
  local executable_command = command.executable_command
  local custom_strategy = options.custom_strategy

  if custom_strategy and type(custom_strategy) == "function" then
    custom_strategy(executable_command, command, options)
  end

  if stratergy == "term" then
    term(executable_command)
  end

  if stratergy == "dispatch" then
    dispatch(executable_command)
  end
end

return M
