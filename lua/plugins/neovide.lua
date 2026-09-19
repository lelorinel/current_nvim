if not vim.g.neovide then return {} end

local font = vim.env.NEOVIDE_FONT or "JetBrainsMono NFM"
local size = vim.env.NEOVIDE_FONT_SIZE or "14"

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + delta
end

local function paste()
  vim.api.nvim_paste(vim.fn.getreg "+", true, -1)
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = {
        -- Nerd Font gerekli: devicon / neo-tree ikonları normal "Fira Code" ile kutu (tofu) olur.
        -- Sistemde kurulu Nerd Font: "JetBrainsMono NFM" (JetBrainsMono Nerd Font Mono).
        -- Boşluklu isim Neovide/lua'da direkt kullanılır, escape gerekmez.
        guifont = font .. ":h" .. size,
      },
      g = {
        -- Performans / yenileme (refresh)
        neovide_refresh_rate = 60,
        neovide_normal_opacity = 1,
        -- Yuvarlak float köşeleri
        neovide_floating_corner_radius = 0.7,
        -- Scroll: anlık (lag yok), uzak satırlarda 5 satır animasyon
        neovide_scroll_animation_length = 0,
        neovide_scroll_animation_far_lines = 5,
        -- İmleç animasyonu ve izi
        neovide_cursor_animation_length = 0.15,
        neovide_cursor_short_animation_length = 0.25,
        neovide_cursor_trail_size = 0.9,
        neovide_cursor_unfocused_outline_width = 0.125,
        neovide_hide_mouse_when_typing = true,
        -- İmleç görsel efektleri
        neovide_cursor_vfx_mode = { "railgun", "pixiedust" },
        neovide_cursor_vfx_particle_lifetime = 0.7,
      },
    },
    mappings = {
      n = {
        -- Ctrl + Scroll ile yakınlaştır / uzaklaştır
        ["<C-ScrollWheelUp>"] = { function() change_scale_factor(0.05) end, desc = "Neovide: zoom in" },
        ["<C-ScrollWheelDown>"] = { function() change_scale_factor(-0.05) end, desc = "Neovide: zoom out" },
      },
      t = {
        -- Neovide/clipboard: terminalde sistem panosundan yapıştır
        ["<sc-v>"] = { '<C-\\><C-n>"+Pi', desc = "Paste from clipboard" },
        ["<C-v>"] = { paste, desc = "Paste" },
      },
      v = {
        ["<C-v>"] = { paste, desc = "Paste" },
      },
      c = {
        ["<C-v>"] = { paste, desc = "Paste" },
      },
    },
  },
}
