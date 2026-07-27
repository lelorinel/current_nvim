-- cache-colorscheme (astrocommunity) son secilen temayi last_colorscheme'e yazar.
-- Huez (lazy=false + import) startup'ta huez-theme dosyasini yukleyip cache'i eziyordu;
-- onur temasi colors_name set etmedigi icin huez restore adiminda default'a dusuyordu.
---@type LazySpec
return {
  { "vague2k/huez.nvim", enabled = false },
  {
    "AstroNvim/astroui",
    opts = function(_, opts)
      local cache = vim.fs.joinpath(vim.fn.stdpath "state", "last_colorscheme")
      local file = io.open(cache, "r")
      if not file then return end
      local name = vim.trim(file:read "*a")
      file:close()
      if name ~= "" then opts.colorscheme = name end
    end,
  },
}
