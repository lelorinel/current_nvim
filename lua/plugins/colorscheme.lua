---@type LazySpec
-- Popüler temaların ortak "iyi" ayarları:
-- şeffaf zemin kapalı, float'lar solid, italik yorumlar/anahtar kelimeler.
-- (nvim.new'in Neovide/catppuccin ayarlarından esinlenildi.)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = false,
      float = { transparent = false, solid = true },
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    opts = {
      transparent = false,
      theme = "wave",
      background = { dark = "wave", light = "lotus" },
      colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
    },
  },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = false,
        dim_inactive = true,
        styles = { comments = { italic = true }, keywords = { italic = true } },
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      transparent_mode = false,
      italic = { strings = false, comments = true, folds = true, operators = false },
    },
  },
  {
    "sainnhe/everforest",
    opts = {
      background = "medium",
      transparent_background = 0,
      italics = true,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      styles = { italic = true },
    },
  },
}
