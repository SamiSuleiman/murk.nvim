# 🚀 `murk.nvim`

Neovim plugin to preview markdown files in your browser:

- Easily preview markdown files in your browser
- Supports custom styling for the preview by providing a CSS file

## ⚡️ Requirements

- Neovim >= 0.7.0
- Pandoc

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "AntennaTower/murk.nvim",
  opts = {},
}
```

## ⚙️ Configuration

**murk.nvim** uses a default configuration, you can override the following options:

Default configuration:

<!-- config:start -->

```lua
{
    css = "/path/to/style.css",
}
```

## 📃 Usage

| Command | Description |
| ------- | ----------- |
| `:MurkStart` | Adds the current file to the list of watched files |
| `:MurkStop` | Stops watching the current file |
| `:MurkStopAll` | Stops watching all files |
| `:MurkOpen` | Opens the preview of the current file (if it's watched)|

<!-- config:end -->
