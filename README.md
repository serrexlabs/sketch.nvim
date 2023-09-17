# Sketch.nvim

Simplify code execution in Neovim. Run and test code snippets effortlessly in various languages, enhancing your coding workflow.


## Introduction

Sketch.nvim is a lightweight plugin for Neovim that simplifies code execution. It allows you to run and test code snippets in various programming languages without leaving the Neovim environment. This can significantly enhance your coding workflow by providing a seamless way to experiment with code, test algorithms, and quickly see the results.

![How to use](https://github.com/serrexlabs/sketch.nvim/assets/4918600/976f53a0-d83b-41f7-b499-3460e030c425)


## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
  {
    'serrexlabs/sketch.nvim',
    config = function()
      require("sketch").setup({})
    end
  }
```

## Usage

Sketch.nvim provides the following commands:

### `:Sketch new`

Use the `:Sketch new` command to create a new sketch. This command will prompt you to choose a programming language and then open a new buffer with the chosen file type. You can start writing and testing your code in the selected language right away.

### `:Sketch run`

The `:Sketch run` command is used to execute the code in the current buffer. It will run the code based on the language associated with the buffer's file type. You can quickly test your code

## Configuration

Sketch.nvim supports various configuration options to customize its behavior. You can specify these options in your Neovim configuration file. Here's an example of configuring Sketch.nvim:

```lua
-- Configuration for Sketch.nvim
require'sketch'.setup({
  executables = {
    typescript = { "bun run", "deno", "ts-node" },
    rust = "rustc",
    lua = "lua",
    python = "python"
  },
  strategy = "term",
  custom_strategy = nil,
  preferred_languages = { "typescript", "rust" }
})
```

### `executables`

Configure executable commands for specific languages. You can specify a single executable command as a string or a table of executable commands for each supported language.

Example:

```lua
executables = {
  typescript = { "bun run", "deno", "ts-node" },
  rust = "rustc",
  lua = "lua",
  python = "python"
}
```

### strategy
Define the environment in which commands should execute. Currently, only the "term" strategy is supported.

```lua
strategy = "term"
```

### custom_strategy
You can specify a custom execution strategy by providing a function. For example:

```lua
custom_strategy = function(command, options)
  -- Your custom execution logic here
end
```

### preferred_languages
Set your preferred languages for creating new sketches. Sketch.nvim will use these languages as options when creating a new sketch.

```lua
preferred_languages = { "typescript", "rust" }
```


