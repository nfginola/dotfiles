# Caps Lock / Escape Swap on TTY Login

Swaps Caps Lock and Escape keys on virtual console (TTY) login. Applied via PAM so it takes effect before the shell starts, without requiring sudo.

## How it works

`/usr/share/kbd/keymaps/swap.map` is loaded by `pam_exec` at session open for every TTY login:

```
# /etc/pam.d/system-login
session    optional   pam_exec.so quiet /usr/bin/loadkeys swap
```

`pam_exec.so quiet` runs the command as root and suppresses output. The `optional` flag means a failure won't block login.

`/etc/vconsole.conf` has no `KEYMAP` entry — `systemd-vconsole-setup` only calls `loadkeys` when `KEYMAP` is set, so omitting it means no keymap is attempted at boot and no error is produced. The service still runs to apply the `FONT` setting.

## Keymap file location

```
/usr/share/kbd/keymaps/swap.map
```

Contents:

```
keymaps 0-2,4-6,8-9,12
keycode 58 = Control
keycode 29 = Caps_Lock
```

Must live under `/usr/share/kbd/keymaps/` using a bare name (no absolute path) so `loadkeys` can find it during early boot before `/usr/local` is mounted. An absolute path into `/usr/local/share/kbd/keymaps/` will fail silently at boot. Also avoid leaving a copy at `/usr/local/share/kbd/keymaps/swap.map` — `loadkeys` searches `/usr/local` first, so that stray file will take precedence and cause the same early-boot failure.

## vconsole.conf and FONT

`/etc/vconsole.conf` currently only sets `FONT=default8x16` with no `KEYMAP`. Without a font set, `systemd-vconsole-setup` can bail out early when `/dev/tty0` isn't fully ready yet (a boot-time race condition), logging "Configuration of first virtual console was skipped" and failing twice before succeeding on a third attempt. Setting a font gives the service a complete config and avoids this.

## Deploy

```bash
sudo cp ../usr/share/kbd/keymaps/swap.map /usr/share/kbd/keymaps/swap.map
bash etc/swapkeys.sh
```

## Reverting

To undo, remove the `pam_exec` line from `/etc/pam.d/system-login`:

```
sudo $EDITOR /etc/pam.d/system-login
```

To restore the keymap at boot instead, set `KEYMAP=swap` in `/etc/vconsole.conf` — but keep the keymap at `/usr/share/kbd/keymaps/swap.map` (bare name) and remove any copy under `/usr/local/share/kbd/keymaps/`.

## Notes

- Applies to TTY logins only (not X11/Wayland graphical sessions).
- For graphical sessions, use `setxkbmap` (X11) or compositor-level config (Wayland).
- Always keep a root session open in another TTY when editing PAM config — a broken PAM stack can lock you out.
