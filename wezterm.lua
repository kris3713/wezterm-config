---@diagnostic disable: missing-fields

local wezterm = require('wezterm')

-- Wezterm font
local wezterm_font = wezterm.font

-- Wezterm config
local config = wezterm.config_builder()

-- Wezterm actions
local action = wezterm.action

-- Change the color scheme:
config.color_scheme = 'Catppuccin Macchiato'

-- Change the default font
config.font = wezterm_font('JetbrainsMono Nerd Font')
config.font_size = 14.5
config.use_resize_increments = true

-- Change the window height and width
config.initial_rows = 24
config.initial_cols = 124

-- Change window tab-bar appearance
config.window_frame = {
  font = wezterm_font({ family = 'Adwaita Sans' }),
  font_size = 11.2,
  active_titlebar_bg = '#333333',
  inactive_titlebar_bg = '#333333',
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}

-- config.window_decorations = 'NONE'

-- Enable scrollbar
config.enable_scroll_bar = true

-- Window padding
config.window_padding = {
  left = '3px',
  right = '3px',
  top = 1.0,
  bottom = 0,
}

-- Change cursor style
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 1.5
-- config.cursor_blink_rate = 800

-- Wezterm multiplexer
local mux = wezterm.mux

-- Set to maximized window on start
wezterm.on('gui-startup', function(cmd)
  ---@diagnostic disable-next-line: unused-local
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Hide the scrollbar when there is no scrollback or alternate screen is active
wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local dimensions = pane:get_dimensions()

  -- Enable scrollbar only if:
  -- 1. There is more content in the scrollback than fits in the viewport
  -- 2. The alternate screen (used by Neovim, Bat, etc.) is NOT active
  overrides.enable_scroll_bar = dimensions.scrollback_rows > dimensions.viewport_rows
    and not pane:is_alt_screen_active()

  window:set_config_overrides(overrides)
end)
-- -- Increase zoom at startup
-- wezterm.on('gui-startup', function(cmd)
--   action.IncreaseFontSize
-- end --[[@param cmd SpawnCommand?]])

-- -- Use integrated blank in the status bar
-- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'

-- Change mouse behaviour for links
config.mouse_bindings = {
  -- Ctrl+Left-click will open the link under the mouse cursor
  {
    event = {
      Up = {
        streak = 1,
        button = 'Left',
      },
    },
    mods = 'CTRL',
    action = action.OpenLinkAtMouseCursor,
  },
  -- Disable opening links with just left click
  {
    event = {
      Up = {
        streak = 1,
        button = 'Left',
      },
    },
    mods = 'NONE',
    action = action.Nop,
  },
  -- Mouse binding for scrolling by 3 lines while holding CTRL
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelUp = 1 },
      },
    },
    mods = 'CTRL',
    action = action.ScrollByLine(-3),
  },
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelDown = 1 },
      },
    },
    mods = 'CTRL',
    action = action.ScrollByLine(3),
  },
  -- Mouse binding for scrolling by one (1)
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelUp = 1 },
      },
    },
    action = action.ScrollByLine(-1),
  },
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelDown = 1 },
      },
    },
    action = action.ScrollByLine(1),
  },
} --[[@as (MouseBinding[])]]

config.keys = {
  -- {
  --   key = 'Backspace',
  --   mods = 'CTRL',
  --   action = action.SendKey {
  --     key = 'w',
  --     mods = 'CTRL'
  --   }
  -- },
  -- Change paste behaviour's to paste from the primary selection.
  {
    key = 'V',
    mods = 'CTRL',
    action = action.PasteFrom('PrimarySelection'),
  },
  -- Toggle Fullscreen with F11
  {
    key = 'F11',
    action = action.ToggleFullScreen,
  },
  -- Disable Alt+Enter
  {
    key = 'Enter',
    mods = 'ALT',
    action = action.Nop,
  },
} --[[@as (Key[])]]

-- and finally, return the configuration to wezterm
return config
