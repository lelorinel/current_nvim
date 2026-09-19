---@type LazySpec
return {
  {
    "nvchad/showkeys",
    cmd = "ShowkeysToggle",
    keys = {
      { "<Leader>uk", "<cmd>ShowkeysToggle<cr>", desc = "Show keys" },
    },
    opts = {
      timeout = 2,
      maxkeys = 7,
      position = "top-right",
      show_count = true,
    },
  },
}
