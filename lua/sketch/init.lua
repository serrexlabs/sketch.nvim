---@toc sketch.nvim

---@divider
---@mod sketch.introduction Introduction
---@brief [[
---Simplify code execution in Neovim. 
---Run and test code snippets effortlessly in
---various languages, enhancing your coding workflow
---@brief ]]
local M = {}

local default_options = {
  executables = {
    typescript = { "bun run", "deno", "ts-node" },
    rust = "rustc",
    lua = "lua",
    python = "python"
  },
  strategy = "term",
  custom_strategy = nil,
  preferred_languages = {}
}

M.options = default_options

---@mod sketch.setup Setup
---@param options table configuration options:
--- * {executables} (table) optional
---   Configuration for executable commands for specific 
---   languages. Each key represents a supported language,
---   and the corresponding value can be a string specifying
---   a single executable command or a table of executable
---   commands for that language.
---   Example:
---   ```
---   executables = {
---     typescript = { "bun run", "deno", "ts-node" },
---     rust = "rustc",
---     lua = "lua",
---     python = "python"
---   }
---   ```
---
--- * {strategy} (string) optional
---   Specifies the execution environment for the commands. 
---   Currently, only 'term' is supported as an environment.
---
--- * {custom_strategy} (function) optional
---   A custom strategy function for executing commands. You
---   can define your own execution strategy and pass it here.
---   The function should take the command string as its 
---   argument.
---   Example:
---   ```lua
---   custom_strategy = function(command)
---     -- Your custom logic here
---     print("Executing custom command:", command)
---   end
---   ```
---
--- * {preferred_languages} (table) optional
---   A table of preferred languages in the order you want 
---   them to appear when choosing the language for code execution.
---   If not specified, all supported languages will be available.
---   Example:
---   ```
---   preferred_languages = { "typescript", "rust" }
---   ```
M.setup = function(options)
  M.options = vim.tbl_deep_extend("force", default_options, options)

---@mod Sketch Commands
---@brief [[
--- The `:Sketch new` command is used to create a new sketch.
--- The `:Sketch run` command executes the code in the current buffer.
---@brief ]]
  vim.cmd('command! -nargs=? Sketch lua require"sketch".runner(<q-args>)')
end

---@private
M.runner = function(arg)
local options = require("sketch").options;
  if arg == "new" then
  require("sketch.file").new(options)
  elseif arg == "run" then
    require("sketch.runner").run_code(options)
  else
    vim.api.nvim_err_write("Invalid argument for Runner. Use 'new' or 'run'.\n")
  end
end

return M
