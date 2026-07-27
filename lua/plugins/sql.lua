---@type LazySpec
-- Fix: nanotee/sqls.nvim deleted require("sqls").on_attach (init.lua).
-- Commands now come from lsp/sqls.lua via vim.lsp.config; the AstroCommunity
-- LspAttach autocmd still calls the old API and errors on every SQL buffer.
return {
  {
    "nanotee/sqls.nvim",
    -- Keep on rtp so lsp/sqls.lua is available before the sqls client starts.
    lazy = false,
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          sqls_attach = false,
        },
      },
    },
  },
}
