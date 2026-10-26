return {
  { "Shatur/neovim-ayu", name = "ayu-dark", priority = 1000 },
  -- Gruvbox
  { "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000 },
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        mini = { enabled = true },
      },
    },
  },
  -- Tokyo Night
  { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
  -- One Dark
  { "navarasu/onedark.nvim", name = "onedark", priority = 1000 },
  -- Nord
  { "shaunsingh/nord.nvim", name = "nord", priority = 1000 },
  -- Dracula
  { "dracula/vim", name = "dracula", priority = 1000 },
  -- Nightfox
  { "EdenEast/nightfox.nvim", name = "nightfox", priority = 1000 },
  -- Rose Pine
  { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
  -- Kanagawa
  { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
  -- Everforest
  { "sainnhe/everforest", name = "everforest", priority = 1000 },
  -- Sonokai
  { "sainnhe/sonokai", name = "sonokai", priority = 1000 },
  -- Material
  { "marko-cerovac/material.nvim", name = "material", priority = 1000 },
  -- Monokai Pro
  { "loctvl842/monokai-pro.nvim", name = "monokai-pro", priority = 1000 },
  -- Solarized Osaka
  { "craftzdog/solarized-osaka.nvim", name = "solarized-osaka", priority = 1000 },
  -- Cyberdream
  { "scottmckendry/cyberdream.nvim", name = "cyberdream", priority = 1000 },
  -- Oxocarbon
  { "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon", priority = 1000 },
  -- Configure LazyVim to load colorscheme
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          "ayu-dark",
          "gruvbox",
          "catppuccin",
          "tokyonight",
          "onedark",
          "nord",
          "dracula",
          "nightfox",
          "rose-pine",
          "kanagawa",
          "everforest",
          "sonokai",
          "material",
          "monokai-pro",
          "solarized-osaka",
          "cyberdream",
          "oxocarbon",
        },
        livePreview = true,
      })
    end,
  },
  -- Load Catppuccin Mocha by default (still swappable with :Themery).
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
