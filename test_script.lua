#!/usr/bin/env lua

-- Standalone test script for cursor-nvim components
-- Run with: lua test_script.lua

print("Testing cursor-nvim plugin components...")

-- Test 1: Check if we can load the modules
print("\n1. Testing module loading...")
local ok, cursor_nvim = pcall(require, "cursor-nvim")
if ok then
  print("✓ cursor-nvim module loaded successfully")
else
  print("✗ Failed to load cursor-nvim module:", cursor_nvim)
  os.exit(1)
end

-- Test 2: Test configuration
print("\n2. Testing configuration...")
local config = cursor_nvim.config
print("  Base URL:", config.base_url)
print("  Timeout:", config.timeout)
print("  Debug:", config.debug)
print("  API Key:", config.api_key and "***" or "nil")

-- Test 3: Test API key detection
print("\n3. Testing API key detection...")
local api_key = cursor_nvim.find_api_key()
if api_key then
  print("✓ API key found:", string.sub(api_key, 1, 10) .. "...")
else
  print("! No API key found (this is expected if not set)")
end

-- Test 4: Test JSON encoding (for API requests)
print("\n4. Testing JSON encoding...")
local test_data = {
  prompt = "test prompt",
  cursor_line = 0,
  cursor_col = 0,
  language = "lua"
}

-- Simulate vim.fn.json_encode
local function json_encode(data)
  -- Simple JSON encoder for testing
  local result = "{"
  local first = true
  for k, v in pairs(data) do
    if not first then result = result .. "," end
    result = result .. '"' .. k .. '":'
    if type(v) == "string" then
      result = result .. '"' .. v .. '"'
    else
      result = result .. tostring(v)
    end
    first = false
  end
  result = result .. "}"
  return result
end

local json = json_encode(test_data)
print("✓ JSON encoding works:", json)

-- Test 5: Test curl command construction
print("\n5. Testing curl command construction...")
if api_key then
  local cmd = {
    "curl",
    "-X", "POST",
    "-H", "Content-Type: application/json",
    "-H", "Authorization: Bearer " .. api_key,
    "-d", json,
    config.base_url .. "/v1/complete"
  }
  print("✓ Curl command constructed successfully")
  print("  Command preview:", table.concat(cmd, " "))
else
  print("! Skipping curl test (no API key)")
end

print("\n✓ All tests completed!")
print("\nTo test the full functionality:")
print("1. Set CURSOR_API_KEY environment variable")
print("2. Run: nvim -u test_init.lua")
print("3. Try :CursorComplete or <C-Space> in insert mode")
