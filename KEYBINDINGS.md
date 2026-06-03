# Neovim Keybindings

> `<Leader>` = `<Space>`

---

## Navigasyon

### Buffer
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<S-h>` | n | Önceki buffer |
| `<S-l>` | n | Sonraki buffer |
| `[b` | n | Önceki buffer |
| `]b` | n | Sonraki buffer |
| `<Leader>bd` | n | Aktif buffer'ı kapat |
| `<Leader>bo` | n | Diğer tüm buffer'ları kapat |

### Tmux / Pencere (vim-tmux-navigator)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `Ctrl+h` | n | Sol pane'e geç |
| `Ctrl+j` | n | Alt pane'e geç |
| `Ctrl+k` | n | Üst pane'e geç |
| `Ctrl+l` | n | Sağ pane'e geç |
| `Ctrl+\` | n | Önceki pane'e geç |

---

## Hareket (Motion)

### Flash.nvim
| Key | Mod | Açıklama |
|-----|-----|----------|
| `s` | n/x/o | Flash (hızlı konum atla) |
| `S` | n/x/o | Flash Treesitter |
| `r` | o | Remote Flash |
| `R` | x/o | Treesitter Search |

### Quick-scope
| Key | Mod | Açıklama |
|-----|-----|----------|
| `f` / `F` | n | Satırda karakter bul (ileri/geri) — vurgu ile |
| `t` / `T` | n | Satırda karakter bul (önünde dur) — vurgu ile |
| `<Leader>uq` | n | Quick-scope aç/kapat |

---

## LSP

### Genel (lspsaga-nvim)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `K` | n | Hover (sembol detayı) |
| `]d` | n | Sonraki diagnostic |
| `[d` | n | Önceki diagnostic |
| `<Leader>la` | n/v | Code action (lspsaga) |
| `<Leader>lA` | n/v | Code action — preview ile (actions-preview) |
| `<Leader>lr` | n | Sembolü yeniden adlandır (lspsaga) |
| `<Leader>lI` | n | Incremental rename (inc-rename) |
| `<Leader>lR` | n | Referansları ara |
| `<Leader>lp` | n | Peek definition |
| `<Leader>lS` | n | Symbols outline |
| `<Leader>lc` | n | Incoming calls |
| `<Leader>lC` | n | Outgoing calls |

### Hover (hover-nvim)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `K` | n | Cursor hover |
| `gK` | n | Seçim hover |
| `]h` | n | Sonraki hover kaynağı |
| `[h` | n | Önceki hover kaynağı |

### Diagnostic
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>uD` | n | Virtual diagnostic satırlarını aç/kapat (lsp_lines) |

---

## Arama & Değiştirme

### Spectre (nvim-spectre)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>ss` | n | Spectre aç |
| `<Leader>sf` | n | Aktif dosyada ara |
| `<Leader>sw` | v | Seçili kelimeyi ara |
| `q` | panel | Quickfix'e gönder |
| `c` | panel | Replace komutunu aç |
| `C` | panel | Bu satırı değiştir |
| `R` | panel | Tüm eşleşmeleri değiştir |
| `v` | panel | Görünüm değiştir |
| `l` | panel | Önceki aramayı devam ettir |

---

## Yank & Register

### Yanky.nvim
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>fy` | n | Yank geçmişini ara |
| `y` | n/x | Yank |
| `p` | n/x | Sonrasına yapıştır |
| `P` | n/x | Öncesine yapıştır |
| `gp` | n/x | Seçimden sonrasına yapıştır |
| `gP` | n/x | Seçimden öncesine yapıştır |
| `]y` | n | Yank geçmişinde ileri |
| `[y` | n | Yank geçmişinde geri |
| `]p` / `[p` | n | Girintili yapıştır (sonra/önce) |
| `>p` / `<p` | n | Yapıştır + sağa/sola girinti |
| `=p` / `=P` | n | Filtreli yapıştır |

### Neoclip (nvim-neoclip-lua)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>fn` | n | Yank geçmişini ara (Telescope) |

---

## Git

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>gB` | n | Git blame aç/kapat |
| `<Leader>g\|` | n | Git graph görüntüle |
| `<Leader>gy` | n/v | Git link kopyala |
| `<Leader>gz` | n/v | Git link tarayıcıda aç |

### Neogit
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>gnt` | n | Neogit aç (tab) |
| `<Leader>gnc` | n | Neogit commit |
| `<Leader>gnf` | n | Neogit float |
| `<Leader>gnh` | n | Neogit yatay split |
| `<Leader>gnv` | n | Neogit dikey split |
| `<Leader>gnd` | n | Neogit (özel dizin) |
| `<Leader>gnk` | n | Neogit (özel kind) |

### Diffview
| Key | Mod | Açıklama |
|-----|-----|----------|
| `:DiffviewOpen` | — | Diff görüntüle (komut) |

---

## Surround (nvim-surround)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `ys{hareket}{karakter}` | n | Çevresine ekle (ör. `ysiw"` → kelimeyi tırnakla) |
| `ds{karakter}` | n | Çevresini sil (ör. `ds"` → tırnakları sil) |
| `cs{eski}{yeni}` | n | Çevresini değiştir (ör. `cs"'` → `"` → `'`) |
| `S{karakter}` | v | Seçimi çevir |

## Treesitter Context (nvim-treesitter-context)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>uT` | n | Context satırını aç/kapat |

## Undotree

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>fu` | n | Undo ağacını aç/kapat |

## Treesj

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>m` | n | Kod bloğunu tek/çok satır arasında geçir |

## Refactoring (refactoring-nvim)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>re` | v | Fonksiyon çıkar |
| `<Leader>rf` | v | Fonksiyonu dosyaya çıkar |
| `<Leader>rv` | v | Değişken çıkar |
| `<Leader>ri` | n/v | Değişkeni inline yap |
| `<Leader>rb` | n/v | Fonksiyon çıkar |
| `<Leader>rbf` | n/v | Fonksiyonu dosyaya çıkar |
| `<Leader>rr` | v | Refactor seç |
| `<Leader>rp` | n/v | Debug: Print |
| `<Leader>rd` | n/v | Debug: Print variable |
| `<Leader>rc` | n/v | Debug: Temizle |

---

## Task Runner (overseer-nvim)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>Mt` | n | Overseer panelini aç/kapat |
| `<Leader>Mc` | n | Komut çalıştır |
| `<Leader>Mr` | n | Task çalıştır |
| `<Leader>Ma` | n | Task action |
| `<Leader>Mi` | n | Overseer bilgisi |
| `q` | panel | Pencereyi kapat |
| `K` / `J` | panel | Detay seviyesini artır/azalt |
| `Ctrl+p` / `Ctrl+n` | panel | Output'ta yukarı/aşağı |

---

## Terminal

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<C-/>` | n/t | Floaterm aç/kapat |
| `<Leader>tF` | n | Floaterm aç/kapat (alternatif) |
| `<Leader>td` | n | LazyDocker terminali |
| `<Leader>ts` | n | Toggleterm yöneticisini aç (Telescope) |

### Toggleterm Manager (panel içi)
| Key | Mod | Açıklama |
|-----|-----|----------|
| `Enter` | n/i | Terminali aç/kapat |
| `r` / `Ctrl+r` | n/i | Terminali yeniden adlandır |
| `d` / `Ctrl+d` | n/i | Terminali sil |
| `n` / `Ctrl+n` | n/i | Yeni terminal oluştur |

---

## Markdown

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>Mp` | n | Markdown önizleme başlat |
| `<Leader>Ms` | n | Markdown önizlemeyi durdur |
| `<Leader>MT` | n | Markdown önizlemeyi aç/kapat |

---

## Dokümantasyon

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>fD` | n | DevDocs aç (Telescope) |
| `<Leader>fdd` | n | Aktif dosya için DevDocs aç |
| `<Leader>fdt` | n | Son DevDocs öğesini aç/kapat |

---

## Çoklu Cursor (vim-visual-multi)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `Ctrl+Up` | n | Yukarıya cursor ekle |
| `Ctrl+Down` | n | Aşağıya cursor ekle |

> Seçili kelimede: `Ctrl+n` — sonraki eşleşmeye cursor ekle (plugin default)

---

## Vurgu (vim-highlighter)

| Key | Mod | Açıklama |
|-----|-----|----------|
| `nn` | n | Sonraki (son eklenen) vurgu |
| `ng` | n | Önceki (son eklenen) vurgu |
| `n[` | n | En yakın sonraki vurgu |
| `n]` | n | En yakın önceki vurgu |

---

## Diagnostics

### Trouble
| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>xx` | n | Belge diagnosticlerini göster |
| `<Leader>xX` | n | Workspace diagnosticlerini göster |
| `<Leader>xL` | n | Location list |
| `<Leader>xQ` | n | Quickfix list |
| `<Leader>xt` | n | Todo listesi |
| `<Leader>xT` | n | Todo/Fix/Fixme listesi |
| `q` / `Esc` | panel | Kapat |

## Colorscheme Picker

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>ft` | n | Tema seçici aç (huez — registry'deki kurulu temalar) |
| `<Leader>fc` | n | Tema seçici aç (Telescope — tüm kurulu temalar, canlı önizleme) |

## UI & Ayarlar

| Key | Mod | Açıklama |
|-----|-----|----------|
| `<Leader>uq` | n | Quick-scope aç/kapat |
| `<Leader>uD` | n | Diagnostic satırlarını aç/kapat |
| `<Leader>uT` | n | Treesitter context aç/kapat |

---

## Pencere Yönetimi (windows-nvim)

Sadece komut olarak tanımlı, keybind yok. Manuel bağlayabilirsin:

| Komut | Açıklama |
|-------|----------|
| `:WindowsMaximize` | Pencereyi maximize et |
| `:WindowsMaximizeVertically` | Dikey maximize |
| `:WindowsMaximizeHorizontally` | Yatay maximize |
| `:WindowsEqualize` | Pencereleri eşitle |
| `:WindowsToggleAutowidth` | Otomatik genişliği aç/kapat |

---

## Çakışmalar & Notlar

| Durum | Eklentiler | Çözüm |
|-------|-----------|-------|
| `<Leader>la` | actions-preview + lspsaga | **Çözüldü** — lspsaga kalır, actions-preview `<Leader>lA` |
| `<Leader>lr` | inc-rename + lspsaga | **Çözüldü** — lspsaga kalır, inc-rename `<Leader>lI` |
| `<Leader>fy` | yanky + neoclip | **Çözüldü** — yanky kalır, neoclip `<Leader>fn` |
| `<Leader>Mt` | overseer + markdown-preview | **Çözüldü** — overseer kalır, markdown preview `<Leader>MT` |
| `K` | hover-nvim + lspsaga | hover-nvim, astrolsp K'yi devre dışı bırakıyor |
