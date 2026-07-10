# dotfiles

This is a compilation of different dotfiles (unix configuration files) that I
use on my Linux machines.

In the future I will try to automate with a script and list all required dependencies.

## Setup Instructions

### Live ISO

1. Boot from live Arch ISO in UEFI mode
2. Update pacman package databases

   ```shell
   pacman -Syy
   ```

3. Install git

   ```shell
   pacman -S git
   ```

4. Clone this repository

   ```shell
   git clone https://github.com/scottzach1/dotfiles.git && cd dotfiles
   ```

5. Update configuration in [0_live_install.sh](0_live_install.sh)

   ```shell
   # Configuration variables
   TARGET_DISK="XXX"  # /dev/nvme0n1
   SWAP_SIZE="16G"
   HOSTNAME="desktop"
   USERNAME="zaci"
   TIMEZONE="Pacific/Auckland"
   LOCALE="en_NZ.utf8"
   KEYMAP="us"
   ```

6. Run live install script

   ```shell
   bash 0_live_install.sh
   ```

### Post Install

1. Reboot into Arch Linux
2. Run post install script

   ```shell
   bash 1_post_install.sh
   ```

## Wayland / Hyprland

This setup targets **Hyprland** on Wayland (the old bspwm/X11 configs are kept
under [`old/`](old/)).

### Layout — built-in `master`

Uses Hyprland's built-in **`master`** layout (no plugins), tuned for the 32:9
ultrawide where BSP tiles poorly. `orientation`/`mfact` give the column
fractions:

- `orientation = center` + `mfact 0.5` → `1/4 | 1/2 | 1/4`
- `orientation = center` + `mfact 0.33` → `1/3 | 1/3 | 1/3`
- `orientation = left` → `1/3 | 2/3`

Key binds: focus `super+j/k/l/;`, master width `super+=/-`, orientation toggle
`super+\`, promote to master `super+a`. (An earlier attempt used the
`hyprscroller` plugin — dropped: it fails to build against Hyprland 0.55.x, and
gating core layout on an out-of-tree plugin is fragile. `master` is bulletproof.)

### NVIDIA (RTX 3080)

Handled by `1_post_install.sh` (`setup_nvidia`), but for reference:

1. Open modules: `nvidia-open-dkms` (in `packages-pacman.lst`).
2. Early KMS: `MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm)` in
   `/etc/mkinitcpio.conf` + `sudo mkinitcpio -P`. (`/etc/modprobe.d/nvidia.conf`
   sets `nvidia_drm modeset=1`.) The install script does both.
3. Keep driver + Hyprland current — explicit sync (fixes most NVIDIA flicker/
   XWayland issues) needs both recent.

### Displays

Monitor config lives in [`monitors.conf`](configs/home/.config/hypr/monitors.conf)
(sourced by `hyprland.conf`). Edit by hand or with the **`nwg-displays`** GUI (the
Wayland arandr-equivalent) — it rewrites that file. Note: the G9's EDID
"preferred" mode mis-selects 3840x1080, so native 5120x1440 is pinned explicitly.

### Day/night theming

**Catppuccin** (Latte ↔ Mocha) driven by **`darkman`** (fixed coords, no
geoclue). Sunrise/sunset run `~/.local/share/{light,dark}-mode.d/desktop.sh`,
which flip hyprland/waybar/kitty/mako/fuzzel + GTK, and set the freedesktop
appearance portal so Firefox/Chrome/GTK4 follow. GTK theme is **Colloid**
(Catppuccin tweak), built by `setup_gtk_theme`. ghostty uses its native
`theme = light:…,dark:…`. Manual test: `darkman set light` / `darkman set dark`.

> Chrome: set **Appearance → Device** so it follows the portal. Keep **Theme:
> GTK** (not "Use QT").

### Notes

- **Config format:** hyprlang. Hyprland 0.55 deprecated hyprlang for **Lua** —
  window rules are commented out pending a Lua migration (the dropdown scratchpad
  still works via its `exec-once` workspace assignment). Everything else is fine
  on hyprlang for now.
- **Login manager:** LightDM, pointed at the `hyprland` session. It launches
  Hyprland fine here; if it ever mis-seeds the Wayland env, `greetd`+`tuigreet`
  or SDDM are cleaner alternatives.
- **JetBrains IDEs:** enable native Wayland mode per-IDE to avoid XWayland blur.
- **Screenshots:** `super+shift+s` → `grim | slurp | swappy` (repo-only).

## Screenshots

> Below are the previous bspwm/X11 setups — pending refresh for Hyprland.

<p align="center">
<img src="https://raw.githubusercontent.com/scottzach1/dotfiles/master/screenshots/desktop-bspwm.png">
</p>

## Author

Zac Scott
