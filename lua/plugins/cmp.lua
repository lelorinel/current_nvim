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

return {
  "saghen/blink.cmp",
  optional = true,
  opts_extend = { "sources.default" },
  opts = function(_, opts)
    opts.fuzzy = vim.tbl_extend("force", opts.fuzzy or {}, {
      implementation = "prefer_rust",
      frecency = { enabled = true },
      use_proximity = true,
    })

    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      min_keyword_length = 0,
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = { async = true, timeout_ms = 300, max_items = 100 },
        buffer = { score_offset = -2, max_items = 50, opts = { use_cache = true } },
        path = { max_items = 30 },
        snippets = { max_items = 30 },
      },
    })

    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      trigger = {
        prefetch_on_insert = true,
        show_on_insert = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_backspace_in_keyword = true,
      },
      list = {
        max_items = 80,
        selection = { preselect = true, auto_insert = false },
      },
      accept = vim.tbl_deep_extend("force", opts.completion and opts.completion.accept or {}, {
        resolve_timeout_ms = 0,
        auto_brackets = {
          semantic_token_resolution = { enabled = false },
        },
      }),
      menu = vim.tbl_deep_extend("force", opts.completion and opts.completion.menu or {}, {
        border = "rounded",
        max_height = 12,
        auto_show_delay_ms = 0,
        direction_priority = { "s", "n" },
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        draw = {
          treesitter = {},
          components = {
            kind_icon = {
              text = function(ctx) return get_kind_icon(ctx).text end,
              highlight = function(ctx) return get_kind_icon(ctx).highlight end,
            },
          },
        },
      }),
      documentation = vim.tbl_deep_extend("force", opts.completion and opts.completion.documentation or {}, {
        auto_show = false,
        treesitter_highlighting = false,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      }),
    })

    opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-n>"] = { "select_next", "show" },
      ["<C-p>"] = { "select_prev", "show" },
    })

    return opts
  end,
  specs = {
    { "ms-jpq/coq_nvim", enabled = false },
    { "ms-jpq/coq.artifacts", enabled = false },
  },
}
