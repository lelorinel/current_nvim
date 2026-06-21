return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"

    opts.window = {
      completion = cmp.config.window.bordered {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
      documentation = cmp.config.window.bordered {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      },
    }

    opts.mapping = cmp.mapping.preset.insert {
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    }

    return opts
  end,
}
