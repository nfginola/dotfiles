local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.audible_bell = 'Disabled'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0

-- Match monitor refresh rate for smooth scrolling (144Hz)
config.max_fps = 144
config.animation_fps = 144
-- Use EGL instead of wgpu/Vulkan on X11 — lower latency rendering path
config.prefer_egl = true

config.enable_tab_bar = false

config.keys = {
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = act.QuickSelectArgs {
      label = 'copy path',
      patterns = {
        '[~/][\\w./-]+',
        '[\\w.-]+/[\\w./-]+',
      },
      action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane)
        wezterm.log_info('Copied path: ' .. sel)
        window:copy_to_clipboard(sel)
      end),
    },
  },
  {
    key = 'u',
    mods = 'CTRL|SHIFT',
    action = act.QuickSelectArgs {
      label = 'copy word',
      patterns = { '[\\w.+-]+' },
      action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane)
        window:copy_to_clipboard(sel)
      end),
    },
  },
}

return config
