local M = {}

-- Plugin configuration
M.config = {
  api_key = nil,
  base_url = "https://api.cursor.com", -- Try the more common domain
  timeout = 5000,
  debug = false,
}

-- Initialize the plugin
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  -- Try to find API key automatically
  if not M.config.api_key then
    M.config.api_key = M.find_api_key()
  end

  if M.config.debug then
    vim.notify("Cursor-Neovim plugin initialized", vim.log.levels.INFO)
  end
end

-- Find Cursor API key from various locations
function M.find_api_key()
  -- Check environment variable first
  local env_key = os.getenv("CURSOR_API_KEY")
  if env_key then
    return env_key
  end

  -- Check common Cursor config locations on macOS
  local config_paths = {
    os.getenv("HOME") .. "/Library/Application Support/Cursor/User/settings.json",
    os.getenv("HOME") .. "/.cursor/settings.json",
    os.getenv("HOME") .. "/.config/cursor/settings.json",
  }

  for _, path in ipairs(config_paths) do
    local file = io.open(path, "r")
    if file then
      local content = file:read("*all")
      file:close()

      -- Try to extract API key from JSON (basic parsing)
      local api_key = content:match('"api_key"%s*:%s*"([^"]+)"')
      if api_key then
        return api_key
      end
    end
  end

  return nil
end

-- Main function to interact with Cursor API
function M.complete()
  if not M.config.api_key then
    vim.notify(
      "Cursor API key not found. Please set CURSOR_API_KEY environment variable or configure it in setup()",
      vim.log.levels.ERROR
    )
    return
  end

  -- Get current buffer content and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Prepare request data
  local request_data = {
    prompt = table.concat(lines, "\n"),
    cursor_line = cursor_pos[1] - 1, -- Convert to 0-based indexing
    cursor_col = cursor_pos[2],
    language = vim.bo.filetype,
  }

  -- Make API request (we'll implement this in api.lua)
  local api = require("cursor-nvim.api")
  api.complete(request_data, function(response)
    if response and response.completion then
      -- Insert completion at cursor position
      vim.api.nvim_put({ response.completion }, "c", true, true)
    end
  end)
end

return M
