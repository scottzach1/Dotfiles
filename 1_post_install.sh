#!/bin/bash
#                 _   _                 _     _
#   ___  ___ ___ | |_| |_ ______ _  ___| |__ / |
#  / __|/ __/ _ \| __| __|_  / _` |/ __| '_ \| |
#  \__ \ (_| (_) | |_| |_ / / (_| | (__| | | | |
#  |___/\___\___/ \__|\__/___\__,_|\___|_| |_|_|
#
#       Zac Scott (github.com/scottzach1)
#
# 1_post_install.sh

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse command line arguments
VERBOSE=0
while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Exit on any error
set -e

# Enable command echoing only if verbose mode is on
if [ "$VERBOSE" -eq 1 ]; then
  set -x
fi

# Set up logging
exec 1> >(tee "$(basename --suffix .sh "$0")_$(date +%Y%m%d_%H%M%S).log")
exec 2>&1

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CLONE_DIR="$HOME/Clone/"

cleanup() {
	local exit_code=$?
	set +x # Turn off command echoing for cleanup
	echo "Script exited with code: $exit_code"
	if [ $exit_code -ne 0 ]; then
		echo "Installation failed! Check the log file for details."
		# Add any necessary cleanup here, like unmounting filesystems
		if mountpoint -q /mnt/boot 2>/dev/null; then
			umount /mnt/boot
		fi
		if mountpoint -q /mnt 2>/dev/null; then
			umount /mnt
		fi
	fi
}

log() {
	local level=$1

	shift
	case "$level" in
	"INFO")
		echo -e "${GREEN}[INFO]${NC} $*"
		;;
	"WARN")
		echo -e "${YELLOW}[WARN]${NC} $*"
		;;
	"ERROR")
		echo -e "${RED}[ERROR]${NC} $*"
		;;
	esac
}

sanity_checks() {
	# Check if script is run as root
  if [ "$EUID" -eq 0 ]; then
      log "ERROR" "This script must not be run as root"
      exit 1
  fi

	# Check internet connectivity
	if ! ping -c 1 archlinux.org >/dev/null 2>&1; then
		error_exit "No internet connection"
	fi

	log "INFO" "All sanity checks passed"
}

setup_things() {
	# Enable time synchronization
	timedatectl set-ntp true
}

copy_configs() {
	log "INFO" "Copying config files to home directory"
	find configs/home -type f -printf '%P\0' |
		while IFS= read -r -d '' item; do
      mkdir -p "$HOME/$(dirname "$item")"
			cp "configs/home/$item" "$HOME/$item"
		done

	log "INFO" "Copy config files to root filesystem"
	find configs/root -type f -printf '%P\0' |
		while IFS= read -r -d '' item; do
      sudo mkdir -p "/$(dirname "$item")"
			sudo cp "configs/root/$item" "/$item"
		done
}

copy_scripts() {
  log "INFO" "Copy scripts to ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  find scripts -type f -printf '%P\0' |
    while IFS= read -r -d '' item; do
      cp "scripts/$item" "$HOME/.local/bin/$item"
    done

}

install_paru_git() {
  if command -v paru >/dev/null 2>&1; then
    log "INFO" "Paru is already installed (skipping install)"
  else
    log "INFO" "Installing paru from git"
    # https://github.com/Morganamilo/paru
    local target_dir="$CLONE_DIR/Aur/paru"
    mkdir -p "$(dirname "$target_dir")"
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git "$target_dir"
    pushd "$target_dir" > /dev/null
    makepkg -si
    popd > /dev/null
  fi
}

install_packages_pacman() {
  log "INFO" "Installing AR packages via pacman"
  # shellcheck disable=SC2046
  paru -S --needed $(cat packages-pacman.lst)
}

install_packages_paru() {
  log "INFO" "Installing AUR packages via paru"
  # shellcheck disable=SC2046
  paru -S --needed $(cat packages-paru.lst)
}

setup_nvidia() {
  # Wayland on the RTX 3080 needs early KMS: the nvidia modules in the initramfs
  # (which also pulls in /etc/modprobe.d/nvidia.conf -> modeset=1, copied by
  # copy_configs). Runs after package install so nvidia-open-dkms + linux-headers
  # are present for the dkms build.
  log "INFO" "Configuring NVIDIA early KMS"
  if ! grep -q '^MODULES=(.*nvidia' /etc/mkinitcpio.conf; then
    log "INFO" "- adding nvidia modules to initramfs MODULES"
    sudo sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  else
    log "INFO" "- nvidia modules already present in MODULES (skipping)"
  fi
  log "INFO" "- regenerating initramfs"
  sudo mkinitcpio -P
}

install_python() {
  log "INFO" "Setting up Python and dependencies"

  if command -v >/dev/null 2>&1; then
    log "INFO" "- uv is already installed (skipping)"
  else
    log "INFO" "- installing astral-sh/uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi
}

setup_nvim() {
  if ! command -v nvim >/dev/null 2>&1; then
    log "INFO" "Neovim is not installed (skipping setup)"
  else
    log "INFO" "Setting up neovim plugins"

    log "INFO" "- Installing junegunn/vim-plug"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    # Run PlugInstall headless
    nvim --headless +PlugInstall +qall
  fi
}

setup_fish() {
  # Prompt is starship now (installed via packages-pacman.lst) and is wired up in
  # config.fish; fish's autosuggestions/syntax-highlighting are built in, so
  # oh-my-fish is no longer needed. Nothing to bootstrap here.
  if command -v starship >/dev/null 2>&1; then
    log "INFO" "starship present; prompt initialised from config.fish"
  else
    log "WARN" "starship not found; prompt will fall back to fish default"
  fi
}

enable_services() {
  log "INFO" "Enabling services via systemctl"
  services=("lightdm" "NetworkManager" "bluetooth" "polkit" "earlyoom" "fstrim.timer")

  for svc in "${services[@]}"; do
    log "INFO" "- enabling $svc"
    sudo systemctl enable --now "$svc"
  done
}

apply_luks_perf() {
  log "INFO" "Applying dm-crypt workqueue bypass for LUKS"
  sudo cryptsetup refresh --perf-no_read_workqueue --perf-no_write_workqueue --allow-discards --persistent luks
}

setup_gtk_theme() {
  # Colloid GTK theme with the Catppuccin tweak (Light + Dark), built from source
  # so we get the catppuccin palette without an unmaintained AUR package. Produces
  # ~/.themes/Colloid-{Light,Dark}-Catppuccin (verify names with `ls ~/.themes`;
  # if they differ, update the gtk-theme references in the darkman mode scripts).
  log "INFO" "Installing Colloid GTK theme (Catppuccin, light+dark)"
  local dir="$CLONE_DIR/Themes/Colloid-gtk-theme"
  if [ ! -d "$dir" ]; then
    mkdir -p "$(dirname "$dir")"
    git clone --depth 1 https://github.com/vinceliuice/Colloid-gtk-theme.git "$dir"
  fi
  pushd "$dir" > /dev/null
  ./install.sh --tweaks catppuccin -c light -c dark || log "WARN" "- Colloid install returned non-zero"
  popd > /dev/null
}

setup_misc() {
  log "INFO" "Setting up miscellaneous things"
  # Wallpaper + lockscreen are declarative now (hypr/hyprpaper.conf, hypr/hyprlock.conf).
  # Layout is the built-in `master` (no plugin) — hyprscroller was dropped after it
  # failed to build against Hyprland 0.55.4 (upstream API rename). Revisit if the
  # plugin catches up; nothing to install here now.
  :
}

# Main installation process
main() {
	sanity_checks
	copy_configs
	copy_scripts
	install_paru_git
	install_packages_pacman
	install_packages_paru
	setup_nvidia
	install_python
	setup_nvim
	setup_fish
	setup_gtk_theme
	setup_misc
	enable_services
	apply_luks_perf

  log "INFO" "Post install setup is complete"
  read -p "Would you like to reboot? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "INFO" "You may run the following you are done"
    log "INFO" "> reboot"
    log "INFO" "exiting gracefully..."
    exit 0
  fi
  log "INFO" "rebooting..."
  reboot
}

# Run the setup
main
