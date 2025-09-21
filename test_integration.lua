-- Integration test for your existing Neovim config
-- Add this to your init.lua or plugins config

-- For lazy.nvim users:
-- {
--   dir = "/Users/judahsullivan/Projects/NeovimPlugins/cursor-nvim",
--   config = function()
--     require("cursor-nvim").setup({
--       debug = true,
--       api_key = os.getenv("CURSOR_API_KEY"),
--     })
--   end
-- }

-- For packer.nvim users:
-- use {
--   dir = "/Users/judahsullivan/Projects/NeovimPlugins/cursor-nvim",
--   config = function()
--     require("cursor-nvim").setup({
--       debug = true,
--       api_key = os.getenv("CURSOR_API_KEY"),
--     })
--   end
-- }

-- Manual setup (add to your init.lua):
vim.opt.runtimepath:prepend("/Users/judahsullivan/Projects/NeovimPlugins/cursor-nvim")
require("cursor-nvim").setup({
  debug = true,
  api_key = os.getenv("CURSOR_API_KEY"),
})
