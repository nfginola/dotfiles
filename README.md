Assumes fresh Arch Linux install.
Uses GNU Stow for deploying.

Dependencies:
- stow
- fd
- git

dotsize.sh:
```
Calculate lean and full size of dotfiles.
These are symlinks to configuration settings in $HOME, which may get populated by system use.

Lean: Important configuration files only, assumes target system regenerates.
Full: Configuration files + any system generated files.

Full relevant if you want to manually export drop-in dotfiles with
system generated files preserved.
```

safe_stow.sh:
```
Deploys symlinks to various directories in $HOME based on the configurations here.
Each unit matches path from $HOME.
This ensures to create backups of the local folders (.bak).
```

save.sh
```
Performs selective post-processing to get a lean snapshot of relevant system details
that are of interest to redeploy (which are otherwise too large, or cumbersome).
```

Docs:
- `bluetooth.md` — Bluetooth audio troubleshooting (adapter pairable/bonding issues)
- `obs-virtualcam.md` — using OBS Virtual Camera to screen-share into Discord
  across workspaces
- `_not_stowable/` — configs that live outside `$HOME` (`/etc`), deployed via
  each subfolder's `setup.sh` instead of stow
