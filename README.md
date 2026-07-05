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
under [`old/`](old/)). Layout is the **hyprscroller** scrolling-column plugin,
chosen for the 32:9 ultrawide where BSP splits tile poorly.

### NVIDIA (RTX 3080)

Wayland on NVIDIA needs a few manual steps the config can't do on its own:

1. Install the open modules: `nvidia-open-dkms` (already in `packages-pacman.lst`).
2. Enable early KMS — add to `/etc/mkinitcpio.conf`:

   ```
   MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm)
   ```

   then regenerate: `sudo mkinitcpio -P`. (`/etc/modprobe.d/nvidia.conf` shipped
   here sets `nvidia_drm modeset=1`.)
3. Keep the driver + Hyprland current — explicit sync (the fix for most NVIDIA
   flicker/XWayland issues) relies on both being recent.

### hyprscroller plugin

Installed by the post-install script, or manually (may need a running session):

```shell
hyprpm add https://github.com/dawsers/hyprscroller
hyprpm enable hyprscroller && hyprpm reload
```

### Notes

- **Login manager:** LightDM is kept and pointed at the `hyprland` session, but
  it is X-oriented and can mis-seed the Wayland session env. If Hyprland won't
  launch cleanly, switch to `greetd`+`tuigreet` (lightweight, Hyprland-friendly)
  or SDDM.
- **JetBrains IDEs:** enable native Wayland mode in each IDE to avoid blurry
  XWayland rendering on the scaled ultrawide.
- **Screenshots:** `super+shift+s` uses `grim | slurp | swappy` (repo-only,
  replacing flameshot).

## Screenshots

> Below are the previous bspwm/X11 setups — pending refresh for Hyprland.

<p align="center">
<img src="https://raw.githubusercontent.com/scottzach1/dotfiles/master/screenshots/desktop-bspwm.png">
</p>

## Author

Zac Scott
