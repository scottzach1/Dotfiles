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

# Exit on any error and show commands being executed
set -e # Exit immediately if a command exits with a non-zero status
set -x  # Print commands and their arguments as they are executed

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
  sudo pacman -S --needed $(cat packages-pacman.lst)
}

install_packages_paru() {
  log "INFO" "Installing AUR packages via paru"
  # shellcheck disable=SC2046
  paru -S --needed $(cat packages-paru.lst)
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
  if ! command -v fish >/dev/null 2>&1; then
    log "INFO" "Fish shell is not installed (skipping setup)"
  else
    log "INFO" "Setting up fish plugins"
    log "INFO" "- Install oh-my-fish/oh-my-pish"
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > omf-install
    fish omf-install --path="$HOME/.local/share/omf" --config="$HOME/.config/omf/config.omf" --noninteractive --yes

    log "INFO" "- Installing scottzach1/dracula-theme-omf"
    fish -c "omf install https://github.com/scottzach1/dracula-theme-omf.git"
    fish -c "omf theme dracula-theme-omf"
  fi
}

# Main installation process
main() {
	sanity_checks
	copy_configs
	install_paru_git
	install_packages_pacman
	setup_nvim
	setup_fish

	log "INFO" "Post install setup is complete, please reboot to continue"
}

# Run the installation
main
