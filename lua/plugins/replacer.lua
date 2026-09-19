---@type LazySpec
return {
  {
    "gabrielpoca/replacer.nvim",
    lazy = true,
    keys = {
      { "<Leader>qr", ':lua require("replacer").run()<cr>', desc = "QuickFix Replacer" },
    },
  },
}
