---@type LazySpec

-- Rounded kenarlar + aralarında boşluk olan iki panelli picker düzeni.
-- (Aralıksız iki kutu bitişince Neovim köşeleri yuvarlayamıyor; araya
--  gövdesiz bir "spacer" box koyarak gap oluşturuyoruz.)
local picker_horiz = {
  reverse = true,
  layout = {
    box = "horizontal",
    width = 0.95,
    height = 0.9,
    border = "none",
    {
      box = "vertical",
      width = 0.45,
      -- List ve input ayrı rounded kutular; aralarında 1 satır boşluk
      { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
      { box = "vertical", height = 1 },
      { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
    },
    { box = "horizontal", width = 2 }, -- paneller arası boşluk
    {
      win = "preview",
      title = " {preview} ",
      border = "rounded",
      title_pos = "center",
      width = 0.5,
    },
  },
}

local picker_vert = {
  layout = {
    backdrop = false,
    fullscreen = true,
    box = "vertical",
    border = "rounded",
    title = " {title} {live} {flags} ",
    title_pos = "center",
    { win = "input", height = 1, border = "bottom" },
    { box = "vertical", height = 1 }, -- input ile list arası boşluk
    { win = "list", border = "none" },
    { box = "vertical", height = 1 }, -- alt preview ile arası boşluk
    { win = "preview", title = " {preview} ", height = 0.4, border = "rounded" },
  },
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- Özel düzenleri kaydet
        layouts = {
          picker_horiz = picker_horiz,
          picker_vert = picker_vert,
        },
        -- Pencere genişliğine göre duyarlı (responsive) düzen
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "picker_horiz" or "picker_vert"
          end,
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = "i" },
              ["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
              ["<C-i>"] = { "toggle_ignored", mode = { "i", "n" } },
              ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
              ["<C-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
              -- Seçilen dosyaları OpenCode'a bağlam olarak gönder
              ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
            },
          },
        },
        -- OpenCode entegrasyonu (nickjvandyke/opencode.nvim)
        actions = {
          opencode_send = function(picker)
            local selected = picker:selected { fallback = true }
            if selected and #selected > 0 then
              local items = vim.tbl_map(function(item)
                return item.file
                    and require("opencode").format { path = item.file, from = item.pos, to = item.end_pos }
                  or item.text
              end, selected)
              picker:close()
              require("opencode").prompt(table.concat(items, ", ") .. " ")
            end
          end,
        },
      },
      -- Terminal ve GitHub pencerelerinde arka planı Normal yap (transparan uyum)
      terminal = { wo = { winhighlight = "Normal:Normal" } },
      gh = { wo = { winhighlight = "Normal:Normal" } },
      -- lazygit'ten dosyayı çalışan neovim'de aç
      lazygit = {
        configure = true,
        config = { os = { editPreset = "nvim-remote" } },
      },
    },
  },
}
