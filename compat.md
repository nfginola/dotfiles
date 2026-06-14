# Dotfiles Portability

| Package       | Portable | Notes                                                                                 |
| ------------- | -------- | ------------------------------------------------------------------------------------- |
| `autorandr`   | No       | Profiles are EDID-fingerprinted to specific monitors; re-save on new hardware         |
| `obs`         | Yes      | Global and user settings only; scenes/sources are in `basic/` and not tracked         |
| `easyeffects` | Yes      | Plugin presets tracked in `db/`                                                        |
| `xorg`        | No       | `.xinitrc` has NVIDIA PRIME setup (`envycontrol`, `xrandr --setprovideroutputsource`) |
| `redshift`    | No       | Hardcoded lat/lon (59.91, 10.75); update for different location                       |
| `i3`          | Partial  | Monitor keybindings assume `external`/`extended` autorandr profiles exist             |
| `bashrc`      | Yes      |                                                                                       |
| `btop`        | Yes      |                                                                                       |
| `dunst`       | Yes      |                                                                                       |
| `fonts`       | Yes      |                                                                                       |
| `git`         | Yes      |                                                                                       |
| `gtk`         | Yes      |                                                                                       |
| `mpv`         | Yes      |                                                                                       |
| `nnn`         | Yes      |                                                                                       |
| `nvim`        | Yes      |                                                                                       |
| `polybar`     | Yes      | Detects monitors dynamically                                                          |
| `qbittorrent` | Yes      |                                                                                       |
| `rofi`        | Yes      |                                                                                       |
| `scripts`     | Yes      |                                                                                       |
| `ssh`         | Yes      | Config only; keys are not tracked                                                     |
| `tmux`        | Yes      |                                                                                       |
| `uv`          | Yes      |                                                                                       |
| `vim`         | Yes      |                                                                                       |
| `wezterm`     | Yes      |                                                                                       |
| `xdg`         | Yes      |                                                                                       |
| `zathura`     | Yes      |                                                                                       |
| `zsh`         | Yes      |                                                                                       |

