---@type LazySpec
-- nickjvandyke/opencode.nvim — OpenCode TUI/API entegrasyonu.
-- Sunucu snacks.terminal içinde SABİT portla `opencode --port <port>` olarak başlatılır
-- ve `server.url` doğrudan o sunucuya sabitlenir. Böylece plugin, TUI'si olmayan
-- başka bir sunucuya bağlanıp "prompt görünmüyor" durumuna düşmez (Windows'ta
-- otomatik CWD eşleştirmesi slash/case yüzünden güvenilmez).
-- Not: sudo-tee/opencode.nvim ile aynı `require("opencode")` modülünü paylaşır; ikisi aynı anda kullanılamaz.
local opencode_port = 47829
local opencode_url = "http://127.0.0.1:" .. opencode_port
local opencode_cmd = "opencode --port " .. opencode_port
---@type snacks.terminal.Opts
local term_opts = { win = { position = "right", enter = false } }

return {
  {
    "nickjvandyke/opencode.nvim",
    version = "*", -- en son stabil sürüm
    -- lazy: ilk tuşta yüklenir
    keys = {
      { "<C-a>", function() require("opencode").ask "@this: " end, mode = { "n", "x" }, desc = "Ask OpenCode…" },
      { "<C-x>", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Select OpenCode…" },
      {
        "go",
        function() return require("opencode").operator "@this " end,
        mode = { "n", "x" },
        expr = true,
        desc = "Append range to OpenCode",
      },
      {
        "goo",
        function() return require("opencode").operator "@this " .. "_" end,
        mode = "n",
        expr = true,
        desc = "Append line to OpenCode",
      },
      {
        "<S-C-u>",
        function() require("opencode").command "session.half.page.up" end,
        mode = "n",
        desc = "Scroll OpenCode up",
      },
      {
        "<S-C-d>",
        function() require("opencode").command "session.half.page.down" end,
        mode = "n",
        desc = "Scroll OpenCode down",
      },
      {
        "<C-.>",
        function() require("snacks.terminal").toggle(opencode_cmd, term_opts) end,
        mode = { "n", "t" },
        desc = "Toggle OpenCode",
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- snacks.terminal'i sunucu başlatmak için kullan
        server = {
          -- Sabit URL: otomatik keşfi atlayıp doğrudan TUI'li sunucuya bağlan
          url = opencode_url,
          start = function()
            require("snacks.terminal").open(opencode_cmd, term_opts)
          end,
        },
      }

      -- Prompt gönderilince OpenCode terminalini öne getir
      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:tui.command.execute",
        callback = function(args)
          local event = args.data.event
          if event and event.properties and event.properties.command == "prompt.submit" then
            local win = require("snacks.terminal").get(opencode_cmd, { create = false })
            if win then win:show() end
          end
        end,
      })
    end,
  },
}
