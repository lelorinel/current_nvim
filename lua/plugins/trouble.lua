---@type LazySpec
return {
  {
    "folke/trouble.nvim",
    opts = {
      auto_close = true, -- boş kalınca otomatik kapan
      auto_refresh = true, -- açıkken otomatik yenile
      modes = {
        -- Yalnızca en yüksek önem derecesindeki tanıları göster (nvim.new)
        cascade = {
          mode = "diagnostics",
          auto_open = false,
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
        },
      },
    },
    keys = {
      { "<Leader>xc", "<cmd>Trouble cascade toggle<cr>", desc = "Trouble Cascade Diagnostics" },
    },
  },
}
