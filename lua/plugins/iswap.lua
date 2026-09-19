---@type LazySpec
return {
  {
    "mizlan/iswap.nvim",
    keys = {
      { "gw", ":ISwapWithRight<cr>", desc = "Swap two arguments" },
      { "<Leader>is", ":ISwap<cr>", desc = "Swap many arguments" },
    },
    opts = { keys = "arstdhneio" },
  },
}
