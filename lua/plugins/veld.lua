vim.filetype.add({ extension = { veld = "veld" } })

return {
  "AstroNvim/astrolsp",
  opts = {
    config = {
      veld = {
        cmd = { "veld", "lsp" },
        filetypes = { "veld" },
        root_markers = { "veld.toml" },
      },
    },
    servers = {
      "veld",
    },
  },
}
