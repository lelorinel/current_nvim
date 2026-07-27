---@type LazySpec
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
      },
      g = {
        -- vim-workspace otherwise autosaves on InsertLeave/BufLeave/FocusLost,
        -- which triggers AstroLSP format_on_save on every mode change.
        workspace_autosave = false,
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
      },
      i = {
        ["<C-s>"] = { "<Esc><cmd>w<cr>", desc = "Save file" },
      },
      v = {
        -- lspsaga öncelikli
        ["<Leader>la"] = { "<cmd>Lspsaga code_action<cr>", desc = "LSP code action" },

        -- actions-preview yeni tuşu
        ["<Leader>lA"] = {
          function() require("actions-preview").code_actions() end,
          desc = "LSP code action (preview)",
        },
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
