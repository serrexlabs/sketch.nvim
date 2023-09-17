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

M.setup = function(options)
  M.options = vim.tbl_deep_extend("force", default_options, options)

  vim.cmd('command! -nargs=? Sketch lua require"sketch".runner(<q-args>)')
end

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
