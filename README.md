# Cursor-Neovim

A Neovim plugin that integrates with Cursor's API to provide AI-powered completions and chat functionality.

## Installation

### Using packer.nvim
```lua
use {
    'your-username/cursor-nvim',
    config = function()
        require('cursor-nvim').setup({
            api_key = "your-api-key-here", -- Optional, will auto-detect
            debug = true, -- Enable debug messages
        })
    end
}
```

### Using lazy.nvim
```lua
{
    'your-username/cursor-nvim',
    config = function()
        require('cursor-nvim').setup({
            api_key = "your-api-key-here",
            debug = true,
        })
    end
}
```

## Configuration

```lua
require('cursor-nvim').setup({
    api_key = "your-cursor-api-key", -- Optional, will auto-detect
    base_url = "https://api.cursor.sh", -- API base URL
    timeout = 5000, -- Request timeout in ms
    debug = false, -- Enable debug messages
    keymaps = {
        complete = "<C-Space>", -- Keymap for completion
        chat = "<leader>cc", -- Keymap for chat
    }
})
```

## Usage

### Commands
- `:CursorComplete` - Get AI completion at cursor position

### Keymaps
- `<C-Space>` (insert mode) - Trigger completion
- `<leader>cc` - Open chat (future feature)

## API Key Setup

The plugin will automatically try to find your Cursor API key from:
1. `CURSOR_API_KEY` environment variable
2. Cursor's configuration files

You can also set it manually in the setup function.

## Features

- [x] AI-powered code completion
- [ ] Chat functionality (planned)
- [ ] Context-aware suggestions
- [ ] Multiple language support

## Requirements

- Neovim 0.7+
- curl (for HTTP requests)
- Valid Cursor API key

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.
# cursor-nvim
