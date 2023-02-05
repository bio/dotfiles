local wezterm = require 'wezterm';

local TITLEBAR_BG_COLOR <const> = "#f0f0f0";

return {
  -- text
  font = wezterm.font_with_fallback({
    "Monaco",
    "Fira Code",
  }),
  font_size = 16.0,
  freetype_load_target = "Normal",
  line_height = 1.02,
  cell_width = 1.04,

  -- window
  use_fancy_tab_bar = true,
  show_new_tab_button_in_tab_bar = false,
  window_decorations = "RESIZE",
  initial_cols = 187,
  initial_rows = 50,
  window_frame = {
    -- The font used in the tab bar
    font = wezterm.font({
      family = "Roboto",
      weight = "Bold",
    }),
    font_size = 11.0,
    active_titlebar_bg = TITLEBAR_BG_COLOR,
    inactive_titlebar_bg = TITLEBAR_BG_COLOR,
  },
  window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = "0.1cell",
    bottom = "0.1cell",
  },

--  adjust_window_size_when_changing_font_size = false,
  colors = {
    foreground = "#000000",
    background = "#ffffff",

    ansi = {"black", "maroon", "green", "olive", "#4285f4", "purple", "teal", "silver"},
    brights = {"grey", "red", "lime", "yellow", "#4285f4", "fuchsia", "aqua", "white"},

    cursor_fg = "#ffffff",
    cursor_bg = "#000000",
    cursor_border = "#000000",

    selection_fg = "#ffffff",
    selection_bg = "#555555",

    tab_bar = {
      background = "#dcdcdc",
      background = "#ffffff",
      background = "#e0e0e0",
      background = TITLEBAR_BG_COLOR,

      active_tab = {
        bg_color = "#ede8ed",
        bg_color = "#ffffff",
        fg_color = "#000000",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      inactive_tab = {
        bg_color = "#cccccc",
        fg_color = "#999999",
        intensity = "Half",
      },
      inactive_tab_hover = {
        bg_color = "#cccccc",
        fg_color = "#999999",
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = TITLEBAR_BG_COLOR,
        fg_color = "#999999",
      },
      new_tab_hover = {
        bg_color = TITLEBAR_BG_COLOR,
        fg_color = "#000000",
      },
    },
  },
}
