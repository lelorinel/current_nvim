return {
  {
    "rktjmp/lush.nvim",
    lazy = true,
  },
  {
    dir = vim.fn.expand("~/.local/state/quickshell/user/generated"),
    name = "matugen-theme",
    lazy = false,
    priority = 1000,
    config = function()
      local theme_file = vim.fn.expand("~/.local/state/quickshell/user/generated/nvim-theme.lua")

      local function apply()
        if vim.fn.filereadable(theme_file) == 1 then
          local ok, theme = pcall(dofile, theme_file)
          if ok and theme and theme.apply then
            theme.apply()
          end
        end
      end

      -- Watch for wallpaper/matugen changes and reapply only if onur is active
      local w = vim.uv.new_fs_event()
      w:start(theme_file, {}, function(err, _, _)
        if not err then
          vim.schedule(function()
            if vim.g.colors_name == "onur" then apply() end
          end)
        end
      end)
    end,
  },
}
