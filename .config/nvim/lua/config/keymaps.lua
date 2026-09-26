-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Seamless navigation between Neovim windows and tmux panes.
-- These override LazyVim's default <C-h/j/k/l> window bindings (which are set
-- just before this file on VeryLazy). When there is no Neovim window in the
-- requested direction, the plugin forwards the key to tmux.
local nav = {
  ["<C-h>"] = { "TmuxNavigateLeft", "Navigate Left" },
  ["<C-j>"] = { "TmuxNavigateDown", "Navigate Down" },
  ["<C-k>"] = { "TmuxNavigateUp", "Navigate Up" },
  ["<C-l>"] = { "TmuxNavigateRight", "Navigate Right" },
}
for lhs, nav_cmd in pairs(nav) do
  vim.keymap.set({ "n", "t" }, lhs, "<cmd><C-U>" .. nav_cmd[1] .. "<cr>", { desc = nav_cmd[2] })
end
