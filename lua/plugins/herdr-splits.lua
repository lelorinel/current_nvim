-- Seamless Ctrl+hjkl navigation + Alt+hjkl resize between Neovim splits and
-- Herdr panes (the Herdr equivalent of vim-tmux-navigator / smart-splits).
-- Only active inside a Herdr-managed pane (HERDR_ENV=1). Outside Herdr,
-- vim-tmux-navigator keeps handling Ctrl+hjkl for tmux.

local function herdr_bin()
  local bin = vim.env.HERDR_BIN_PATH
  if bin == nil or bin == "" then bin = "herdr" end
  return bin
end

local function herdr_query(args)
  local cmd = { herdr_bin() }
  vim.list_extend(cmd, args)
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then return nil end
  local ok, decoded = pcall(vim.json.decode, out)
  if not ok then return nil end
  return decoded
end

-- Cycle focus across workspaces (spaces) when at the left/right edge.
local function focus_relative_workspace(delta)
  local data = herdr_query({ "workspace", "list" })
  local list = data and data.result and data.result.workspaces
  if not list or #list < 2 then return end
  table.sort(list, function(a, b) return (a.number or 0) < (b.number or 0) end)
  local cur = 1
  for i, w in ipairs(list) do
    if w.focused then cur = i break end
  end
  local target = ((cur - 1 + delta) % #list) + 1
  herdr_query({ "workspace", "focus", list[target].workspace_id })
end

-- Cycle focus across agents when at the top/bottom edge.
local function focus_relative_agent(delta)
  local data = herdr_query({ "agent", "list" })
  local list = data and data.result and data.result.agents
  if not list or #list < 2 then return end
  local cur = 1
  for i, a in ipairs(list) do
    if a.focused then cur = i break end
  end
  local target = ((cur - 1 + delta) % #list) + 1
  local t = list[target]
  herdr_query({ "agent", "focus", t.pane_id or t.terminal_id })
end

-- Fires only at the true edge (no Neovim split and no Herdr pane to cross).
-- left/right -> move between spaces; up/down -> move between agents.
local function at_edge(ctx)
  if ctx.is_sidebar then return end
  local d = ctx.direction
  if d == "left" then
    focus_relative_workspace(-1)
  elseif d == "right" then
    focus_relative_workspace(1)
  elseif d == "up" then
    focus_relative_agent(-1)
  elseif d == "down" then
    focus_relative_agent(1)
  end
end

---@type LazySpec
return {
  -- Avoid the Ctrl+hjkl clash: let vim-tmux-navigator load only outside Herdr.
  {
    "christoomey/vim-tmux-navigator",
    cond = vim.env.HERDR_ENV ~= "1",
  },

  {
    "lmilojevicc/herdr-splits.nvim",
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    opts = {
      at_edge = at_edge,
    },
    keys = {
      { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate/space left" },
      { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate/agent down" },
      { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate/agent up" },
      { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate/space right" },
      { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
      { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
      { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
      { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
    },
  },
}
