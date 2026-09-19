---@type LazySpec

-- Snacks explorer'ı aç/kapat. Açarken mevcut dosyayı "reveal" eder ki
-- doğru dosya/dizin gösterilsin.
local function explorer_toggle()
  local snacks = require "snacks"
  local open = snacks.picker.get { source = "explorer" }
  if open and #open > 0 then
    for _, p in ipairs(open) do p:close() end
  else
    snacks.explorer.reveal()
  end
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        -- edgy/panel split açılışında görünüm zıplamasın
        splitkeep = "screen",
        -- SCM (git) kullanıldığı için swap/backup dosyaları gereksiz
        swapfile = false,
        backup = false,
        -- Kenarda daha fazla bağlam
        scrolloff = 9,
      },
      g = {
        -- vim-workspace otherwise autosaves on InsertLeave/BufLeave/FocusLost,
        -- which triggers AstroLSP format_on_save on every mode change.
        workspace_autosave = false,
        -- snacks animasyonlarını kapat (nvim.new'den)
        snacks_animate = false,
      },
    },
    mappings = {
      n = {
        ["<Esc>"] = {
          function()
            vim.cmd.nohlsearch()
            pcall(function() require("hlslens").stop() end)
          end,
          desc = "Clear search highlight",
        },
        ["<Leader><Leader>"] = { "<cmd>Telescope find_files<cr>", desc = "Find files" },
        -- Explorer: neo-tree kırık olduğu için Snacks explorer (sağlam)
        ["<Leader>e"] = { explorer_toggle, desc = "Toggle Explorer" },
        ["<Leader>o"] = { explorer_toggle, desc = "Toggle Explorer Focus" },
        -- Tuş kısayollarını ara (Snacks picker, bulanık arama). Kolay erişim için F1.
        ["<F1>"] = { function() require("snacks").picker.keymaps() end, desc = "Search keymaps" },
        ["<Leader>?"] = { function() require("snacks").picker.keymaps() end, desc = "Search keymaps" },
        ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>bd"] = {
          function() require("astrocore.buffer").close() end,
          desc = "Close current buffer",
        },
        ["<Leader>bo"] = {
          function()
            local current = vim.api.nvim_get_current_buf()
            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
              if bufnr ~= current then
                local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
                if buftype == "" then require("astrocore.buffer").close(bufnr) end
              end
            end
          end,
          desc = "Close all other buffers",
        },

        -- lspsaga öncelikli — actions-preview ve inc-rename'in üzerine yaz
        ["<Leader>la"] = { "<cmd>Lspsaga code_action<cr>", desc = "LSP code action" },
        ["<Leader>lr"] = { "<cmd>Lspsaga rename<cr>", desc = "Rename current symbol" },

        -- actions-preview yeni tuşu
        ["<Leader>lA"] = {
          function() require("actions-preview").code_actions() end,
          desc = "LSP code action (preview)",
        },

        -- inc-rename yeni tuşu
        ["<Leader>lI"] = {
          function() return ":" .. "IncRename " .. vim.fn.expand "<cword>" end,
          expr = true,
          desc = "Incremental rename",
        },

        -- neoclip yeni tuşu (yanky <Leader>fy'de kalır)
        ["<Leader>fn"] = {
          function() require("telescope").extensions.neoclip.default() end,
          desc = "Find yanks (neoclip)",
        },

        -- Quick-scope toggle düzeltmesi (astrocommunity <Cmd>QuickScopeToggle yanlış)
        ["<Leader>uq"] = { "<Plug>(QuickScopeToggle)", desc = "Toggle quick-scope" },

        -- Telescope colorscheme picker (tüm kurulu temaları gösterir)
        ["<Leader>fc"] = { "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Find colorschemes" },

        -- Markdown Preview toggle — <Leader>Mt overseer'da, büyük T kullan
        ["<Leader>MT"] = { "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle markdown preview" },

        -- Floaterm toggle
        ["<F12>"] = { "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm" },

        -- Manuel kaydetme
        ["<C-s>"] = { "<cmd>w<cr>", desc = "Save file" },

        -- ==== nvim.new (ornicar) uyarlamaları ====
        -- Dosya yolunu panoya kopyala
        ["<Leader>cp"] = {
          function()
            local path = vim.fn.expand "%:p"
            vim.fn.setreg("*", path)
            vim.fn.setreg("+", path)
            vim.notify("Yol kopyalandı: " .. path, vim.log.levels.INFO)
          end,
          desc = "Copy file path",
        },
        -- Dosyayı diskten sil ve buffer'ı kapat
        ["<Leader>bD"] = {
          function()
            local file = vim.fn.expand "%:p"
            if file ~= "" and vim.fn.filereadable(file) == 1 then
              vim.fn.delete(file)
              vim.cmd "bd!"
              vim.notify("Silindi: " .. file, vim.log.levels.WARN)
            else
              vim.notify("Silinecek kayıtlı dosya yok", vim.log.levels.WARN)
            end
          end,
          desc = "Delete file",
        },
        -- Diğer pencereleri kapat
        ["<Leader>wo"] = { "<cmd>only<cr>", desc = "Close other windows" },
        -- Üst/alt boş satır ekle (count destekli)
        ["[<space>"] = {
          function() vim.cmd "call append(line('.') - 1, repeat([''], v:count1))" end,
          desc = "Put empty line above",
        },
        ["]<space>"] = {
          function() vim.cmd "call append(line('.'), repeat([''], v:count1))" end,
          desc = "Put empty line below",
        },
        -- Son değişen/yapıştırılan metni tekrar seç
        ["<Leader>v"] = {
          '"`[" . strpart(getregtype(), 0, 1) . "`]"',
          expr = true,
          desc = "Visually select changed text",
        },
        -- Son yanlış yazılan kelimeyi düzelt (spell)
        ["<C-z>"] = { "[s1z=", desc = "Correct latest misspelled word" },
      },
      i = {
        ["<C-s>"] = { "<Esc><cmd>w<cr>", desc = "Save file" },
        -- Insert modda undo break-point'leri (nvim.new)
        [","] = { ",<c-g>u" },
        ["."] = { ".<c-g>u" },
        [";"] = { ";<c-g>u" },
        -- Son yanlış yazılan kelimeyi düzelt (spell)
        ["<C-z>"] = { "<C-g>u<Esc>[s1z=`]a<C-g>u", desc = "Correct latest misspelled word" },
      },
      v = {
        -- lspsaga öncelikli
        ["<Leader>la"] = { "<cmd>Lspsaga code_action<cr>", desc = "LSP code action" },

        -- actions-preview yeni tuşu
        ["<Leader>lA"] = {
          function() require("actions-preview").code_actions() end,
          desc = "LSP code action (preview)",
        },
        -- Girinti sonrası seçimi koru (nvim.new)
        ["<"] = { "<gv", desc = "Indent right" },
        [">"] = { ">gv", desc = "Indent left" },
      },
      c = {
        -- Komut modunda dosya dizinini genişlet (nvim.new)
        ["%%"] = { "<C-R>=expand('%:h').'/'<cr>" },
      },
      t = {
        -- Floaterm içindeyken de kapat
        ["<F12>"] = { "<cmd>FloatermToggle<cr>", desc = "Toggle Floaterm" },
        -- Terminal insert modundan çık (normal moda geç)
        ["<Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
      },
    },
  },
}
