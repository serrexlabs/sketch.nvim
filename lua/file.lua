local M = {}

M.new = function(options)
  local preferred_languages = options.preferred_languages or {}
  local filetypes = {
    { name = "typescript", description = "TypeScript", extension = 'ts'},
    { name = "rust",       description = "Rust", extension = 'rs' },
    { name = "lua",        description = "Lua", extension = 'lua' },
    { name = "python",     description = "Python", extension = 'py'},
  }

  local filtered_filetypes = {}
  local language_choices = {}
  local choice_map = {} -- Map choice numbers to filetypes

  for i, lang in ipairs(preferred_languages) do
    for _, filetype in ipairs(filetypes) do
      if lang == filetype.name then
        table.insert(filtered_filetypes, filetype)
        choice_map[filetype.name] = i
        break
      end
    end
  end

  if #filtered_filetypes == 0 then
    print("No preferred languages found in the options.")
    return
  end

  -- Sort the filtered filetypes based on the order of preferred languages
  table.sort(filtered_filetypes, function(a, b)
    local choice_a = choice_map[a.name] or 0
    local choice_b = choice_map[b.name] or 0
    return choice_a < choice_b
  end)

  for i, filetype in ipairs(filtered_filetypes) do
    local choice_number = i
    if choice_map[filetype.name] then
      choice_number = choice_map[filetype.name]
    end
    table.insert(language_choices, choice_number .. ": " .. filetype.description)
  end

  if #language_choices == 0 then
    print("No preferred languages to choose from.")
    return
  end

  for _, choice in ipairs(language_choices) do
    print(choice)
  end

  local choice = tonumber(vim.fn.input("Choose an option (default 1): ")) or 1

  if choice > 0 and choice <= #filtered_filetypes then
    local selected_filetype = filtered_filetypes[choice]
    local fileType_extension = selected_filetype.extension

    local unique_name = "sketch_" .. vim.fn.localtime() .. "." .. fileType_extension

    local temp_file_path = vim.fn.tempname() .. unique_name

    vim.cmd("edit " .. temp_file_path)
    vim.bo.filetype = selected_filetype.name
    vim.cmd("startinsert")
  else
    print("Invalid choice.")
  end
end

return M
