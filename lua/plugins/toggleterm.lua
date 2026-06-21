return {
  "akinsho/toggleterm.nvim",
  opts = {
    float_opts = {
      border = "curved",
      width = function() return math.floor(vim.o.columns * 0.85) end,
      height = function() return math.floor(vim.o.lines * 0.85) end,
    },
  },
}
