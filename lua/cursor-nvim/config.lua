local M = {}

-- Default configuration
M.defaults = {
  api_key = nil,
  base_url = "https://api.cursor.com",
  timeout = 5000,
  debug = false,
  keymaps = {
    complete = "<C-Space>",
    chat = "<leader>cc",
  },
  commands = {
    complete = "CursorComplete",
    chat = "CursorChat",
  },
}

-- Merge user config with defaults
function M.setup(user_config)
  user_config = user_config or {}
  return vim.tbl_deep_extend("force", M.defaults, user_config)
end

return M
