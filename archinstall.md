# Arch Linux Installation Guide

> Personal installation guide for my specific hardware setup (AMD/NVIDIA hybrid, btrfs, i3).
> Not a general-purpose guide.

Reference: https://wiki.archlinux.org/title/Installation_guide

---

## Initial Install (Live ISO)

If you see a black screen on boot, disable modesetting by pressing `e` on the GRUB install entry and appending `nomodeset`.
See: https://wiki.archlinux.org/title/Kernel_mode_setting#Disabling_modesetting

```bash
setfont ter-i14b
```

Swap Caps Lock and Ctrl for the install session. Without `keymaps 0-63`, `loadkeys` only patches the plain (unmodified) row - other modifier-state rows keep their old mapping, causing sticky/locking input.

```bash
dumpkeys | grep "^keymaps" > /tmp/swap.map
echo "keycode 58 = Control" >> /tmp/swap.map
echo "keycode 29 = Caps_Lock" >> /tmp/swap.map
loadkeys /tmp/swap.map
```

Verify UEFI and network:

```bash
cat /sys/firmware/efi/fw_platform_size  # should return 64
ip link
ping archlinux.org
```

For wireless: https://wiki.archlinux.org/title/Iwd#iwctl

```bash
timedatectl set-timezone Europe/Oslo
timedatectl set-ntp true
```

Partition the disk. Reference: https://wiki.archlinux.org/title/Installation_guide#Format_the_partitions

```bash
fdisk -l  # find your target disk

fdisk /dev/<your_disk>
# g  - create new GPT table
# n  - create new partition (+1G for EFI, +64G for swap, rest for root)
# p  - verify layout
# w  - write and exit

mkfs.fat -F32 -n "EFI" /dev/efi_partition
mkswap -L "swap" /dev/swap_partition
mkfs.btrfs -L "arch" /dev/root_partition

swapon /dev/swap_partition
lsblk -f
```

Create btrfs subvolumes. Reference: https://wiki.archlinux.org/title/Btrfs

```bash
mount /dev/root_partition /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@data
btrfs subvolume create /mnt/@snapshots

btrfs subvolume list -t /mnt

umount /mnt
```

Mount subvolumes. `noatime` disables last-access timestamp writes; `compress=zstd` enables transparent compression.

```bash
mount -o noatime,compress=zstd,subvol=@ /dev/root_partition /mnt
mkdir -p /mnt/{boot/efi,home,data,.snapshots}
mount -o noatime,compress=zstd,subvol=@home /dev/root_partition /mnt/home
mount -o noatime,compress=zstd,subvol=@data /dev/root_partition /mnt/data
mount -o noatime,compress=zstd,subvol=@snapshots /dev/root_partition /mnt/.snapshots
mount /dev/efi_partition /mnt/boot/efi
```

Install the base system:

| Package             | Purpose                                                             |
| ------------------- | ------------------------------------------------------------------- |
| `base`              | Minimal Arch userspace (glibc, bash, coreutils, pacman)             |
| `linux`             | Latest mainline kernel                                              |
| `linux-lts`         | LTS kernel - fallback if mainline has regressions                   |
| `linux-lts-headers` | Headers for LTS kernel, required for DKMS modules (e.g. NVIDIA)    |
| `linux-firmware`    | Firmware blobs for hardware (WiFi, GPU microcode, etc.)             |
| `btrfs-progs`       | btrfs userspace tools, required for fsck and management             |
| `amd-ucode`         | AMD CPU microcode updates, patches CPU bugs/vulnerabilities at boot |
| `less`              | Pager for long output, required by many tools                       |

```bash
pacstrap -K /mnt base linux linux-lts linux-lts-headers linux-firmware btrfs-progs amd-ucode less
```

Generate fstab. `fstab` tells systemd what to mount on every boot - `/` is the critical entry.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab  # verify
```

---

## Initial Arch Chroot

```bash
arch-chroot /mnt
```

### Install

```bash
pacman -S vim sudo networkmanager ufw grub efibootmgr os-prober
```

### Post-Setup

Configure the system:

```bash
# Timezone
ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
timedatectl  # verify
hwclock --systohc

# Locale - uncomment en_US.UTF-8, nb_NO.UTF-8, sv_SE.UTF-8
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "dev" > /etc/hostname
```

TTY keyboard - Caps/Ctrl swap via PAM. `pam_exec` runs `loadkeys` as root at every TTY session open, before the shell starts. See `~/dotfiles/_not_stowable/swapkeys/` for the setup script.

```bash
sudo mkdir -p /usr/share/kbd/keymaps
sudo tee /usr/share/kbd/keymaps/swap.map << 'EOF'
keymaps 0-2,4-6,8-9,12
keycode 58 = Control
keycode 29 = Caps_Lock
EOF

# Add to /etc/pam.d/system-login:
# session    optional   pam_exec.so quiet /usr/bin/loadkeys swap
echo "session    optional   pam_exec.so quiet /usr/bin/loadkeys swap" | sudo tee -a /etc/pam.d/system-login
```

> Keep a root session open in another TTY when editing PAM config - a broken stack can lock you out.
> For X11, `setxkbmap` handles this later (wired into i3 via `n_set_kbm.sh`).

Users and sudo:

```bash
passwd  # set root password

# Uncomment: %wheel ALL=(ALL:ALL) ALL
visudo

useradd -m -G wheel -s /bin/bash nad
passwd nad
```

Enable services:

```bash
sudo ufw enable
sudo systemctl enable --now ufw
systemctl enable NetworkManager
```

GRUB bootloader:

```bash
cat /sys/firmware/efi/fw_platform_size  # verify 64-bit UEFI

# Mount Windows EFI temporarily so os-prober can detect it
lsblk -f
mkdir -p /mnt/windows-efi
mount /dev/windows_efi_partition /mnt/windows-efi
os-prober  # verify Windows is found

echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

reboot
```

---

## Post-Reboot

If `amdgpu` fails to boot (error -22, black screen), try the LTS kernel and set it as default:

```bash
vim /etc/default/grub
# Set: GRUB_DEFAULT="Advanced options for Arch Linux>Arch Linux, with Linux linux-lts"
grub-mkconfig -o /boot/grub/grub.cfg
```

### Install

```bash
# grub-btrfs
pacman -S grub-btrfs rsync arch-install-scripts autorandr

# NVIDIA + AMD drivers
pacman -S nvidia-open-lts nvidia-utils nvidia-settings nvidia-prime xf86-video-amdgpu vulkan-radeon vulkan-tools
yay -S envycontrol
# sudo envycontrol --switch hybrid  (default, recommended)
# sudo envycontrol --switch integrated
# sudo envycontrol --switch nvidia
# Requires restart - rebuilds initramfs

# Snapshots
pacman -S snapper snap-pac

# Terminal tools
pacman -S wezterm tmux zsh nnn git curl wget openssh ripgrep fd jq unzip btop ncdu stow base-devel fzf zoxide s-tui zathura redshift fastfetch imagemagick neovim

# Home directory
pacman -S xdg-user-dirs

# Display server and window manager
# For xorg: choose all extra packages (default), man-db, ttf-dejavu
pacman -S xorg xorg-xinit i3-wm i3status rofi dunst maim xclip feh picom
pacman -S thunar obsidian qbittorrent gimp
pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu
yay -S brave-bin i3lock-color xkb-switch  # i3lock-color replaces i3lock, do not install both

# Audio
pacman -S pipewire pipewire-jack pipewire-pulse pipewire-alsa wireplumber alsa-utils pamixer pavucontrol

# Video
pacman -S ffmpeg mpv yt-dlp

# Storage - gvfs-mtp pulls gvfs-udisks2-volume-monitor which handles automounting
pacman -S gvfs-mtp

# Bluetooth
pacman -S bluez bluez-utils

# Power management
pacman -S tlp tlp-rdw

# Misc
pacman -S tree-sitter-cli luarocks polybar expac  # tree-sitter runtime pulled in as dep
```

### Post-Setup

```bash
# Rebuild GRUB config to include snapshot entries, then keep it in sync
grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable --now grub-btrfsd.service

# NVIDIA dynamic boost
nvidia-smi  # verify driver
sudo systemctl enable --now nvidia-powerd

# snapper - wants to create /.snapshots itself but @snapshots is already mounted there.
# Unmount, let snapper create its config, then replace its subvolume with ours.
umount /.snapshots
rm -rf /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mount -o noatime,compress=zstd,subvol=@snapshots /dev/nvme0n1p3 /.snapshots
chmod 750 /.snapshots
snapper -c root create --description "fresh install"
sudo systemctl enable --now snapper-cleanup.timer

# Terminal
fastfetch
chsh -s /usr/bin/zsh
fc-cache -fv  # fonts

# Home directory
sudo chown -R nad:nad /data
mkdir -p /data/dev /data/dl /data/games /data/media/gallery /data/media/docs
ln -s /data/dev ~/dev
ln -s /data/dl ~/dl
ln -s /data/games ~/games
ln -s /data/media ~/media
ln -s /data/media/docs ~/docs
mkdir -p ~/.config
cat > ~/.config/user-dirs.dirs << 'EOF'
XDG_DESKTOP_DIR="$HOME"
XDG_DOWNLOAD_DIR="$HOME/dl"
XDG_DOCUMENTS_DIR="$HOME/docs"
XDG_MUSIC_DIR="$HOME/media"
XDG_PICTURES_DIR="$HOME/media/gallery"
XDG_VIDEOS_DIR="$HOME/media/gallery"
XDG_PROJECTS_DIR="$HOME/dev"
XDG_TEMPLATES_DIR="$HOME"
XDG_PUBLICSHARE_DIR="$HOME"
EOF
xdg-user-dirs-update

# Dotfiles
mkdir -p ~/dotfiles && cd ~/dotfiles && git init
# After stowing, re-save autorandr profiles - they are EDID-fingerprinted and hardware-specific.
# See compat.md. With monitors connected in each desired layout:
#   autorandr --save external   (external only)
#   autorandr --save laptop     (laptop only)
#   autorandr --save extended   (both)
# stow <package>          - create symlinks
# stow -D <package>       - remove symlinks
# stow -R <package>       - restow (remove and recreate)
# stow --adopt <package>  - adopt existing files into the package

# zinit (zsh plugin manager)
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
# uv (Python manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
# Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Audio
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Bluetooth
sudo systemctl enable --now bluetooth

# Power management
sudo systemctl enable --now tlp
sudo systemctl enable --now NetworkManager-dispatcher
sudo tlp start
```

---

## Snapper Reference

```bash
snapper -c root list                        # list all snapshots
snapper -c root create --description "..."  # manual snapshot
snapper -c root delete <number>             # delete snapshot
snapper -c root delete <n1>-<n2>            # delete range
snapper -c root undochange <from>..<to>     # undo changes between snapshots
snapper -c root undochange <number>..0      # undo everything since snapshot N
btrfs filesystem du -s /.snapshots          # disk space used by snapshots
vim /etc/snapper/configs/root               # edit limits and cleanup policy
```
