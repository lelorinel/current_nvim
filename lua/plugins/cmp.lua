---@type function?, function?
local icon_provider, hl_provider

local function get_kind_icon(ctx)
  if not icon_provider then
    local _, mini_icons = pcall(require, "mini.icons")
    if _G.MiniIcons then
      icon_provider = function(c)
        local is_specific_color = c.kind_hl and c.kind_hl:match "^HexColor" ~= nil
        if c.item.source_name == "LSP" then
          local icon, hl = mini_icons.get("lsp", c.kind or "")
          if icon then
            c.kind_icon = icon
            if not is_specific_color then c.kind_hl = hl end
          end
        elseif c.item.source_name == "Path" then
          c.kind_icon, c.kind_hl = mini_icons.get(c.kind == "Folder" and "directory" or "file", c.label)
        elseif c.item.source_name == "Snippets" then
          c.kind_icon, c.kind_hl = mini_icons.get("lsp", "snippet")
        elseif c.item.source_name == "Buffer" then
          c.kind_icon, c.kind_hl = mini_icons.get("lsp", "Text")
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      if lspkind_avail then
        icon_provider = function(c)
          if c.item.source_name == "LSP" then
            local icon = lspkind.symbol_map[c.kind]
            if icon then c.kind_icon = icon end
          elseif c.item.source_name == "Snippets" then
            local icon = lspkind.symbol_map.Snippet
            if icon then c.kind_icon = icon end
          end
        end
      end
    end
    if not icon_provider then icon_provider = function() end end
  end

  if not hl_provider then
    local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
    if highlight_colors_avail then
      local kinds
      hl_provider = function(c)
        if not kinds then kinds = require("blink.cmp.types").CompletionItemKind end
        if c.item.kind == kinds.Color then
          local doc = vim.tbl_get(c, "item", "documentation")
          if doc then
            local color_item = highlight_colors.format(doc, { kind = kinds[kinds.Color] })
            if color_item and color_item.abbr_hl_group then
              if color_item.abbr then c.kind_icon = color_item.abbr end
              c.kind_hl = color_item.abbr_hl_group
            end
          end
        end
      end
    end
    if not hl_provider then hl_provider = function() end end
  end

  icon_provider(ctx)
  hl_provider(ctx)
  return { text = ctx.kind_icon .. ctx.icon_gap, highlight = ctx.kind_hl }
end

-- Richer completion UI: signatures, examples, and label details from LSP resolve.
return {
  "saghen/blink.cmp",
  optional = true,
  opts_extend = { "sources.default" },
  opts = function(_, opts)
    opts.fuzzy = vim.tbl_extend("force", opts.fuzzy or {}, {
      implementation = "prefer_rust",
      -- Default floor(#kw/4) lets "hello" match labels that don't contain those chars.
      -- 0 = fzf-like: query chars must appear in order (no typo budget).
      max_typos = 0,
      frecency = { enabled = true },
      use_proximity = true,
      sorts = {
        -- emmet_ls HER kelimeye `<kelime></kelime>` üretir; menüde `~` ile görünür.
        -- "exact" sıralaması skora bakmaz (boolean karşılaştırır), o yüzden `acc`
        -- yazınca emmet exact-eşleşmeyle `access?` gibi gerçek LSP sonucunun önüne
        -- geçip <CR>'ı gasp ediyordu. score_offset ile çözülmez, o yüzden emmet'i
        -- sıralamada en alta it: normal sonuçlar üstte, emmet yine listede dursun.
        function(a, b)
          local function is_emmet(item)
            return item.client_name == "emmet_ls" or item.client_name == "emmet_language_server"
          end
          local ae, be = is_emmet(a), is_emmet(b)
          if ae ~= be then return be end
        end,
        "exact",
        "score",
        "sort_text",
      },
    })

    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      -- Don't open the menu on a single letter / empty keyword spam.
      min_keyword_length = 1,
      default = { "lsp", "path", "snippets", "buffer" },
      -- OpenCode "Ask" penceresinde LSP + buffer tamamlaması (opencode.nvim)
      per_filetype = { opencode_ask = { "lsp", "buffer" } },
      providers = {
        -- Give LSP time to resolve detail/docs (examples, signatures).
        lsp = {
          async = true,
          timeout_ms = 2000,
          max_items = 100,
          -- `{` gibi prefix'siz tetiklenmede LSP'den gelen snippet-kind ıvır
          -- zıvır (örn. emmet'in `{}` üretimi) menüde tek başına kalıp <CR>'ı
          -- gasp etmesin: keyword yoksa snippet-kind LSP item'larını ele.
          transform_items = function(ctx, items)
            local kw = ""
            if ctx and ctx.get_keyword then kw = ctx:get_keyword() or "" end
            if kw == "" then
              local snippet_kind = vim.lsp.protocol.CompletionItemKind.Snippet
              return vim.tbl_filter(function(item) return item.kind ~= snippet_kind end, items)
            end
            return items
          end,
        },
        -- Buffer is the usual source of "random word" fuzzy hits.
        buffer = {
          score_offset = -5,
          max_items = 12,
          min_keyword_length = 3,
          opts = { use_cache = true },
        },
        path = { max_items = 30 },
        snippets = { max_items = 20, min_keyword_length = 2 },
      },
    })

    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      trigger = {
        prefetch_on_insert = true,
        -- Avoid dumping unrelated items the moment you enter insert.
        show_on_insert = false,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_backspace_in_keyword = true,
      },
      list = {
        max_items = 50,
        selection = { preselect = true, auto_insert = false },
      },
      accept = vim.tbl_deep_extend("force", opts.completion and opts.completion.accept or {}, {
        -- Was 0 — that aborted LSP resolve so docs/examples never arrived.
        resolve_timeout_ms = 500,
        auto_brackets = {
          enabled = true,
          semantic_token_resolution = { enabled = false },
        },
      }),
      menu = vim.tbl_deep_extend("force", opts.completion and opts.completion.menu or {}, {
        -- Rounded kenarlıklı, sade menü (doc/signature pencereleriyle uyumlu).
        border = "rounded",
        max_height = 14,
        auto_show_delay_ms = 0,
        direction_priority = { "s", "n" },
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        draw = {
          -- Highlight LSP labels (types / signatures in the menu row)
          treesitter = { "lsp" },
          padding = { 0, 1 },
          gap = 1,
          -- label | kind | LSP detail (örn. Field / u8) | kaynak (lsp/snip/buf)
          columns = {
            { "label" },
            { "kind", gap = 1 },
            { "label_description", gap = 1 },
            { "source_name", gap = 1 },
          },
          components = {
            kind_icon = {
              text = function(ctx) return get_kind_icon(ctx).text end,
              highlight = function(ctx) return get_kind_icon(ctx).highlight end,
            },
            label_description = {
              width = { max = 40 },
              highlight = "BlinkCmpLabelDescription",
            },
            source_name = {
              width = { max = 8 },
              text = function(ctx)
                local name = ctx.item.source_name or ""
                if name == "LSP" then return "lsp" end
                if name == "Snippets" then return "snip" end
                if name == "Buffer" then return "buf" end
                if name == "Path" then return "path" end
                return name:sub(1, 6):lower()
              end,
              highlight = "BlinkCmpSource",
            },
          },
        },
      }),
      documentation = vim.tbl_deep_extend("force", opts.completion and opts.completion.documentation or {}, {
        auto_show = true,
        auto_show_delay_ms = 120,
        update_delay_ms = 50,
        treesitter_highlighting = true,
        window = {
          border = "rounded",
          min_width = 30,
          max_width = 90,
          max_height = 28,
          scrollbar = true,
          direction_priority = {
            menu_south = { "e", "w", "s", "n" },
            menu_north = { "e", "w", "n", "s" },
          },
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      }),
    })

    -- Function signature / parameter help while typing calls
    opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = true,
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    })

    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      -- Terminals commonly encode Ctrl+Space as NUL, which Neovim exposes as <C-@>.
      ["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-n>"] = { "select_next", "show" },
      ["<C-p>"] = { "select_prev", "show" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    })

    return opts
  end,
  specs = {
    { "ms-jpq/coq_nvim", enabled = false },
    { "ms-jpq/coq.artifacts", enabled = false },
    -- blink signature window replaces AstroLSP's native signature_help
    {
      "AstroNvim/astrolsp",
      optional = true,
      opts = function(_, opts)
        opts.features = opts.features or {}
        opts.features.signature_help = false
        return opts
      end,
    },
  },
}
