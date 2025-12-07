return {
  -- add catppuccin
  { "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000 },
  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
