local wezterm = require 'wezterm'

local TITLEBAR_BG_COLOR <const> = '#f0f0f0'

return {
  -- text
  font = wezterm.font('Monaco'),
  font_size = 16,
  -- iTerm2 style with anti-aliasing disabled
  freetype_load_target = 'Mono',
  freetype_load_flags = 'NO_AUTOHINT',
  line_height = 0.98,
  cell_width = 1.04,

  max_fps = 120,
  mouse_wheel_scrolls_tabs = false,

  -- window
  use_fancy_tab_bar = true,
  show_close_tab_button_in_tabs = false,
  show_new_tab_button_in_tab_bar = false,
  window_decorations = 'NONE',
  initial_cols = 171,
  initial_rows = 50,
  window_frame = {
    -- The font used in the tab bar
    font = wezterm.font({
      family = 'Roboto',
      weight = 'Bold',
    }),
    font_size = 11.0,
    active_titlebar_bg = TITLEBAR_BG_COLOR,
    inactive_titlebar_bg = TITLEBAR_BG_COLOR,
  },
  window_padding = {
    left = '0.8cell',
    right = '0.8cell',
    top = '0.2cell',
    bottom = '0.3cell',
  },

  keys = {
    -- Override Cmd+F to open search without using selection
    {
      key = 'f',
      mods = 'SUPER',
      action = wezterm.action.Search { CaseSensitiveString = '' },
    },
  },

  colors = {
    foreground = '#000000',
    background = '#ffffff',

    ansi = {'black', 'maroon', 'green', 'olive', '#4285f4', 'purple', 'teal', 'silver'},
    brights = {'grey', 'red', 'lime', 'yellow', '#4285f4', 'fuchsia', 'aqua', 'white'},

    cursor_fg = '#ffffff',
    cursor_bg = '#000000',
    cursor_border = '#000000',

    selection_fg = '#ffffff',
    selection_bg = '#555555',

    tab_bar = {
      background = TITLEBAR_BG_COLOR,

      active_tab = {
        bg_color = '#ffffff',
        fg_color = '#000000',

        -- Specify whether you want 'Half', 'Normal' or 'Bold' intensity for the
        -- label shown for this tab.
        -- The default is 'Normal'
        intensity = 'Normal',

        -- Specify whether you want 'None', 'Single' or 'Double' underline for
        -- label shown for this tab.
        -- The default is 'None'
        underline = 'None',

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      inactive_tab = {
        bg_color = '#cccccc',
        fg_color = '#999999',
        intensity = 'Half',
      },
      inactive_tab_hover = {
        bg_color = '#cccccc',
        fg_color = '#999999',
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = TITLEBAR_BG_COLOR,
        fg_color = '#999999',
      },
      new_tab_hover = {
        bg_color = TITLEBAR_BG_COLOR,
        fg_color = '#000000',
      },
    },
  },

  scrollback_lines = 50000,
}
