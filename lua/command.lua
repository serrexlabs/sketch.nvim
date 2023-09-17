local M = {}

local function split_command_string(command_string)
  local command, args = command_string:match("([^%s]+)%s(.+)")
  if not command then
    command = command_string
    args = ""
  end

  local escaped_args = {}
  for arg in args:gmatch("%S+") do
    table.insert(escaped_args, arg)
  end

  return command, escaped_args
end

local function get_command(executables)
  local results = {}

  if type(executables) == "string" then
    results.command, results.args = split_command_string(executables)
    if vim.fn.executable(results.command) == 1 then
      return results
    else
      return nil
    end
  end

  if type(executables) == "table" then
    for _, executable in ipairs(executables) do
      results.command, results.args = split_command_string(executable)
      if vim.fn.executable(results.command) == 1 then
        return results
      end
    end
  end

  return nil
end

local function get_os_options(command, filepath)
  local results = {}
  local path
  if vim.fn.has("win32") == 1 then
    -- Windows
    results.file_basepath = vim.fn.fnameescape(filepath:match("^(.*)[\\/]"))
    results.directory_change_command = "cd /d"
    path = vim.fn.system("where " .. command)
  else
    -- Unix-like systems
    results.file_basepath = vim.fn.fnameescape(filepath:match("^(.*)[/]"))
    results.directory_change_command = "cd"
    path = vim.fn.system("which " .. command)
  end

  if path ~= "" then
    results.command_path = vim.fn.substitute(path, "\n", "", "")
    return results
  else
    return nil
  end
end

M.get_executable_command = function(executables, filepath)
  if not executables then
    return nil
  end

  local results = get_command(executables)

  if not results then
    return nil
  end

  local os_options = get_os_options(results.command, filepath)

  if not os_options then
    return nil
  end

  results.full_command = os_options.command_path

  if #results.args > 0 then
    results.full_command = results.full_command .. " " .. table.concat(results.args, " ")
  end


  local change_working_dir = os_options.directory_change_command .. " ".. os_options.file_basepath
  local filename = vim.fn.fnamemodify(filepath, ":t")
  results.executable_command = change_working_dir.. " && " .. results.full_command .. " ./" .. filename

  -- Append the Rust's compiled binary for execution
  if results.command == 'rustc' then
    local filename_without_extension = filename:gsub("%..*", "")
    results.executable_command = results.executable_command .. " && ./" .. filename_without_extension
  end

  return results
end

return M
