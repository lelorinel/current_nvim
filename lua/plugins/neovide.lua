if not vim.g.neovide then return {} end

local font = vim.env.NEOVIDE_FONT or "Envy Code R"
local size = vim.env.NEOVIDE_FONT_SIZE or "14"

return {
  "AstroNvim/astrocore",
  opts = {
    options = {
      opt = {
        guifont = font .. ":h" .. size,
      },
    },
  },
}
