-- Theme persistence
--
-- Persists the selected colorscheme to config/theme_state.lua (tracked in the
-- dotfiles repo so the choice syncs across machines). The state file returns a
-- plain string, e.g. `return "night-owl"`.
--
-- load() is called after lazy.setup() in config/lazy.lua.
-- save() is called from the ColorScheme autocmd in config/autocmds.lua.

local M = {}

local FALLBACK = "dracula"
local STATE_MODULE = "config.theme_state"

-- Persistence is disabled until load() has applied the saved theme. This
-- prevents the ColorScheme events emitted by theme plugins during their own
-- startup setup() from clobbering the persisted choice.
M.ready = false

-- Absolute path to the tracked state file (sibling of this module).
local function state_path()
  local this = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(this, ":h") .. "/theme_state.lua"
end

-- Read the persisted theme name, falling back to FALLBACK on any error.
function M.current()
  package.loaded[STATE_MODULE] = nil
  local ok, name = pcall(require, STATE_MODULE)
  if ok and type(name) == "string" and name ~= "" then
    return name
  end
  return FALLBACK
end

-- Apply the persisted theme. Falls back to FALLBACK if the saved colorscheme
-- is not installed/loadable.
function M.load()
  local name = M.current()
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok and name ~= FALLBACK then
    pcall(vim.cmd.colorscheme, FALLBACK)
  end
  -- Only persist user-initiated changes from here on.
  M.ready = true
end

-- Persist a theme name to the tracked state file.
function M.save(name)
  if not M.ready then
    return -- ignore startup ColorScheme events
  end
  if type(name) ~= "string" or name == "" then
    return
  end
  if name == M.current() then
    return -- avoid needless git churn
  end
  local file, err = io.open(state_path(), "w")
  if not file then
    vim.notify("theme: could not write state file: " .. tostring(err), vim.log.levels.WARN)
    return
  end
  file:write(string.format("return %q\n", name))
  file:close()
  package.loaded[STATE_MODULE] = nil
end

return M
