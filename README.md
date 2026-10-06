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

## Light / dark theme

**Dracula** by night, **Catppuccin Latte** by day, switched at sunset/sunrise by
[`darkman`](https://gitlab.com/WhyNotHugo/darkman) (fixed Auckland coordinates in
`~/.config/darkman/config.yaml`; no geoclue).

- bspwmrc starts `darkman.service` and runs `~/.config/bspwm/theme-apply` at login.
- darkman runs `~/.local/share/{light,dark}-mode.d/desktop.sh`, which call
  `theme-apply light|dark`. That re-colours bspwm borders, swaps the polybar /
  dunst / rofi palette symlinks (`colors.ini`, `dunstrc.d/50-theme.conf`,
  `colors.rasi`) and reloads them, rewrites terminator's palette (new windows),
  sets the wallpaper, and flips GTK.
- GTK3 on X11 reads XSETTINGS, so `xsettingsd` is reloaded with the new theme
  (Ant-Dracula ↔ Colloid-Light-Catppuccin, built by `setup_gtk_theme`).
- `gsettings color-scheme` drives the freedesktop appearance portal
  (xdg-desktop-portal-gtk), which Chrome, Electron apps, libadwaita, kitty
  (`{dark,light}-theme.auto.conf`) and ghostty (`theme = light:…,dark:…`) follow.
- Chrome: set **Settings → Appearance → Mode → Device**.

Manual: `darkman set light`, `darkman set dark`, `darkman toggle`.

## Screenshot laptop w/ bspwm + polybar

<p align="center">
<img src="https://raw.githubusercontent.com/scottzach1/dotfiles/master/screenshots/laptop-bspwm.png">
</p>

## Screenshot laptop w/ i3wm + bumblebee status

<p align="center">
<img src="https://raw.githubusercontent.com/scottzach1/dotfiles/master/screenshots/laptop-i3wm.png">
</p>

## Screenshot desktop w/ bspwm + polybar

<p align="center">
<img src="https://raw.githubusercontent.com/scottzach1/dotfiles/master/screenshots/desktop-bspwm.png">
</p>

## Author

Zac Scott
