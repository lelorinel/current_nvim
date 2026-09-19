---@type LazySpec
-- Neo-tree devre dışı.
-- Bu ortamda neo-tree tekrar tekrar şu hataları veriyordu (kapatıp açınca, tema
-- değiştirince, session restore sonrası):
--   nui/split:    Invalid window id
--   renderer.lua: E95: Buffer with this name already exists
-- Yerine Snacks explorer kullanılıyor (<Leader>e / <Leader>o, astrocore.lua'da).
-- Neo-tree'yi tekrar denemek istersen bu satırı sil ve util/neotree.lua'daki
-- workaround'u geri getir.
return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
}
