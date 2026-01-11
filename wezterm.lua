---@module 'wezterm'
---@type Wezterm
local Wezterm = require('wezterm')

-- Wezterm actions
local action = Wezterm.action

-- Session manager
local session_manager = require('wezterm-session-manager/session-manager')

Wezterm.on('save_session', function(window)
  session_manager.save_state(window)
end)

Wezterm.on('load_session', function(window)
  session_manager.load_state(window)
end)

Wezterm.on('restore_session', function(window)
  session_manager.restore_state(window)
end)

-- This will hold the configuration.
local config = Wezterm.config_builder()

-- Change the color scheme:
config.color_scheme = 'Catppuccin Macchiato'

-- Change the default font
config.font = Wezterm.font('JetbrainsMono Nerd Font')
config.font_size = 14.0

-- Change the window height and width
config.initial_rows = 24
config.initial_cols = 125

-- Change window tab-bar appearance
config.window_frame = {
  font = Wezterm.font { family = 'Adwaita Sans' },
  font_size = 11.0,
  active_titlebar_bg = '#333333',
  inactive_titlebar_bg = '#333333'
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757'
  }
}

-- config.window_decorations = 'NONE'

-- Window padding
config.window_padding = {
  left = '2px',
  right = '1px',
  top = 0,
  bottom = 0
}

-- Change cursor style
config.default_cursor_style = 'BlinkingBar'
config.cursor_thickness = 1.5
-- config.cursor_blink_rate = 800

-- Set to maximized window on start
local mux = Wezterm.mux
Wezterm.on('gui-startup', function(cmd)
  ---@diagnostic disable-next-line: unused-local
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- -- Use integrated blank in the status bar
-- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'

-- Change mouse behaviour for links
config.mouse_bindings = {
  -- Ctrl+Left-click will open the link under the mouse cursor
  {
    event = {
      Up = {
        streak = 1,
        button = 'Left'
      }
    },
    mods = 'CTRL',
    action = action.OpenLinkAtMouseCursor
  },
  -- Disable opening links with just left click
  {
    event = {
      Up = {
        streak = 1,
        button = 'Left'
      }
    },
    mods = 'NONE',
    action = action.Nop
  },
  -- Mouse binding for scrolling by one (1) line while holding CTRL
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelUp = 1 }
      }
    },
    mods = 'CTRL',
    action = action.ScrollByLine(-1)
  },
  {
    event = {
      Down = {
        streak = 1,
        button = { WheelDown = 1 }
      }
    },
    mods = 'CTRL',
    action = action.ScrollByLine(1)
  }
}

-- Set leader key bindings
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
  -- Change paste behaviour's to paste from the primary selection.
  { key = 'V', mods = 'CTRL', action = action.PasteFrom 'PrimarySelection' },
  -- Toggle Fullscreen with F11
  { key = 'F11', action = action.ToggleFullScreen },
  -- Disable Alt+Enter
  { key = 'Enter', mods = 'ALT', action = action.Nop },
  -- Add a keybind for splitting the current pane horizontally
  {
    key = '\\',
    mods = 'LEADER',
    action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Add a keybind for splitting the current pane vertically
  {
    key = '-',
    mods = 'LEADER',
    action = action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Send 'CTRL-A' to the terminal when pressing CTRL-A, CTRL-A
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = action.SendKey { key = 'a', mods = 'CTRL' },
  },
  -- Session manager keybinds
  {
    key = 'S',
    mods = 'LEADER',
    action = action { EmitEvent = 'save_session' }
  },
  {
    key = 'L',
    mods = 'LEADER',
    action = action { EmitEvent = 'load_session' }
  },
  {
    key = 'R',
    mods = 'LEADER',
    action = action { EmitEvent = 'restore_session' }
  }
}

-- Enable scrollbar
config.enable_scroll_bar = true

-- and finally, return the configuration to wezterm
return config
