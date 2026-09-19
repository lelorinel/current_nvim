---@type LazySpec
return {
  {
    "deponian/nvim-base64",
    version = "*",
    keys = {
      { "<Leader>ba", "<Plug>(FromBase64)", mode = "x", desc = "Base64 decode" },
      { "<Leader>bA", "<Plug>(ToBase64)", mode = "x", desc = "Base64 encode" },
    },
    config = function() require("nvim-base64").setup() end,
  },
}
