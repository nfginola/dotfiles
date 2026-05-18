# Gaming Dependencies

Assuming you have a stable system, we can start pulling in dependencies for gaming.

## Enable multilib

Uncomment the following in `/etc/pacman.conf`:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

## Install

```bash
sudo pacman -Sy
sudo pacman -S steam lutris gamemode lib32-gamemode winetricks lib32-nvidia-utils mangohud gamescope flatpak
```

| Package           | Purpose                                                        |
| ----------------- | -------------------------------------------------------------- |
| `steam`           | Game launcher, includes Proton for Windows games               |
| `lutris`          | Non-Steam game launcher, manages its own Wine runners per-game |
| `gamemode`        | Performance daemon - activate per-game via launch options      |
| `lib32-gamemode`  | 32-bit gamemode support, required for most Windows games       |
| `winetricks`        | Installs Windows runtimes (DirectX, VC++, etc.) for Lutris     |
| `lib32-nvidia-utils`  | 32-bit NVIDIA Vulkan driver, required for Windows games via Proton/Wine |
| `mangohud`            | In-game overlay showing FPS, GPU/CPU usage, temps, frametimes           |
| `gamescope`           | Wayland compositor for games - upscaling, framerate limiting, HDR       |
| `flatpak`             | Universal package manager (used for XIVLauncher — FFXIV launcher)       |

## Final Fantasy XIV

Install XIVLauncher and Flatseal via Flatpak:

```bash
flatpak install flathub dev.goats.xivlauncher
flatpak install flathub com.github.tchx84.Flatseal  # Flatseal — manage Flatpak permissions
```

Flatseal is required to grant XIVLauncher access to a custom install directory outside the Flatpak default.

Reference: https://goatcorp.github.io/faq/steamdeck

### Adding XIVLauncher to Lutris

In Lutris, click **+** > "Add locally installed game":

- **Game info tab — Runner:** Flatpak
- **Game options tab — Application ID:** `dev.goats.xivlauncher`

XIVLauncher manages its own Wine environment, so no Wine runner is needed in Lutris.

## Post-Setup

### Game install paths

**Steam:** Settings > Storage > click `+` > set path to `~/games/steam` > set as default.

**Lutris:** Preferences > System > set "Games folder" to `~/games/lutris`.

`~/games` is symlinked to `/data/games` — rerouting here keeps games on the data subvolume which survives reinstalls.

