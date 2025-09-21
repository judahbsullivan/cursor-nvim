local M = {}

-- HTTP client using curl (fallback to other methods if needed)
local function make_request(url, data, headers, callback)
  local config = require("cursor-nvim").config
  
  -- Debug output
  if config.debug then
    vim.notify("Making API request to: " .. url, vim.log.levels.INFO)
  end
  
  local json_data = vim.fn.json_encode(data)

  -- Build curl command
  local cmd = {
    "curl",
    "-X",
    "POST",
    "-H",
    "Content-Type: application/json",
    "-H",
    "Authorization: Bearer " .. config.api_key,
    "-d",
    json_data,
    url,
  }

  -- Add additional headers
  for key, value in pairs(headers or {}) do
    table.insert(cmd, "-H")
    table.insert(cmd, key .. ": " .. value)
  end

  -- Debug: Show the command being executed
  if config.debug then
    vim.notify("Executing: " .. table.concat(cmd, " "), vim.log.levels.INFO)
  end

  -- Execute request
  local handle = io.popen(table.concat(cmd, " ") .. " 2>&1") -- Capture stderr too
  local response = handle:read("*all")
  local success, exit_reason, exit_code = handle:close()

  if config.debug then
    vim.notify("Response: " .. (response or "No response"), vim.log.levels.INFO)
    vim.notify("Exit code: " .. tostring(exit_code), vim.log.levels.INFO)
  end

  if success and exit_code == 0 then
    local ok, parsed = pcall(vim.fn.json_decode, response)
    if ok then
      callback(parsed)
    else
      vim.notify("Failed to parse API response: " .. response, vim.log.levels.ERROR)
      callback(nil)
    end
  else
    vim.notify("API request failed (exit code " .. tostring(exit_code) .. "): " .. (response or "Unknown error"), vim.log.levels.ERROR)
    callback(nil)
  end
end

-- Complete function
function M.complete(data, callback)
  local config = require("cursor-nvim").config
  
  -- Try different possible API endpoints
  local possible_urls = {
    config.base_url .. "/v1/complete",
    config.base_url .. "/api/v1/complete", 
    config.base_url .. "/complete",
    "https://api.cursor.sh/v1/complete",
    "https://api.cursor.com/v1/complete",
  }
  
  -- For now, let's try the first one and add more debugging
  local url = possible_urls[1]
  
  if config.debug then
    vim.notify("Trying API endpoint: " .. url, vim.log.levels.INFO)
  end

  make_request(url, data, {}, callback)
end

-- Chat function (for future expansion)
function M.chat(messages, callback)
  local config = require("cursor-nvim").config
  local url = config.base_url .. "/v1/chat"

  make_request(url, { messages = messages }, {}, callback)
end

return M
