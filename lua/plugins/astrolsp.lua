---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = false, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- conform.nvim (plugins/conform.lua) üzerinden formatlıyoruz
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration passed to `vim.lsp.config`
    -- client specific configuration can also go in `lsp/` in your configuration root (see `:h lsp-config`)
    config = {
      -- ["*"] = { capabilities = {} }, -- modify default LSP client settings such as capabilities
      tailwindcss = {
        -- fivem-next monorepo: plugin UI'ları apps/gateway/src/plugins/*/nui|server
        -- altında ama tailwind v4 projesi (index.css + @source) apps/nui'da.
        -- Varsayılan root detection bu dosyaları repo köküne (.git) bağlıyor,
        -- server orada tailwind projesi bulamayıp susuyor → `bg-red-` önerisi yok.
        -- Bu dosyaları apps/nui projesine bağla.
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname ~= "" then
            local repo = fname:match("^(.-)/apps/gateway/src/plugins/[^/]+/nui/")
              or fname:match("^(.-)/apps/gateway/src/plugins/[^/]+/server/")
            if repo then
              local nui_root = repo .. "/apps/nui"
              if vim.fn.isdirectory(nui_root) == 1 then
                on_dir(nui_root)
                return
              end
            end
          end
          -- Diğer dosyalar: lspconfig varsayılan tailwind root detection.
          -- (package.json sadece tailwindcss bağımlılığı varsa marker sayılır)
          local markers = {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "postcss.config.js",
            "postcss.config.cjs",
            "postcss.config.mjs",
            "postcss.config.ts",
            "package.json",
            ".git",
          }
          local results = vim.fs.find(markers, { path = fname, upward = true, limit = math.huge })
          for _, p in ipairs(results) do
            if vim.fs.basename(p) ~= "package.json" then
              on_dir(vim.fs.dirname(p))
              return
            end
            local ok, lines = pcall(vim.fn.readfile, p)
            if ok then
              local text = table.concat(lines, "\n")
              if text:find('"tailwindcss"%s*:') or text:find('"@tailwindcss/[^"]*"%s*:') then
                on_dir(vim.fs.dirname(p))
                return
              end
            end
          end
        end,
      },
    },
    -- customize how language servers are attached
    handlers = {},
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lsp-attach`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
