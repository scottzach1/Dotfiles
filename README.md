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
