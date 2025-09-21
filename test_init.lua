-- Test configuration for cursor-nvim plugin
-- Usage: nvim -u test_init.lua

-- Set up basic vim options
vim.opt.runtimepath:prepend("/Users/judahsullivan/Projects/NeovimPlugins/cursor-nvim")

-- Load the plugin
require("cursor-nvim").setup({
  debug = true, -- Enable debug messages
  api_key = "key_fea244943e4d41b6cde7c1c9fc034658853f5223e0a9ba0af7b365d5de69b124", -- Your personal API key
})

-- Create a test buffer with some code
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Create a test file
    vim.cmd("edit test_file.lua")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      "-- Test file for cursor-nvim",
      "local function test_function()",
      "  -- Place cursor here and test completion",
      "  return",
      "end"
    })
    
    -- Position cursor at line 3, column 2 (after the comment)
    vim.api.nvim_win_set_cursor(0, {3, 2})
    
    print("Test setup complete!")
    print("Try :CursorComplete or <C-Space> to test completion")
    print("Use :lua require('cursor-nvim').find_api_key() to test API key detection")
  end
})

-- Add some helpful commands for testing
vim.api.nvim_create_user_command("TestAPIKey", function()
  local key = require("cursor-nvim").find_api_key()
  if key then
    print("API Key found: " .. string.sub(key, 1, 10) .. "...")
  else
    print("No API key found")
  end
end, { desc = "Test API key detection" })

vim.api.nvim_create_user_command("TestConfig", function()
  local config = require("cursor-nvim").config
  print("Current config:")
  for k, v in pairs(config) do
    if k ~= "api_key" then
      print("  " .. k .. ": " .. tostring(v))
    else
      print("  " .. k .. ": " .. (v and "***" or "nil"))
    end
  end
end, { desc = "Show current configuration" })
