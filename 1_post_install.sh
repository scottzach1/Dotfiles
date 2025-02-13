#!/bin/bash

# Configuration variables

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

# User validation
confirmation_prompt() {
	local question="$1"
	read -p "$question (y/N) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		log "ERROR" "Operation cancelled by user"
		exit 1
	fi
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
			cp --interactive "$item" "$HOME/$item"
		done

	log "INFO" "Copy config files to root filesystem"
	find configs/root -type f -printf '%P\0' |
		while IFS= read -r -d '' item; do
      sudo mkdir -p "/$(dirname "$item")"
			sudo cp --interactive "$item" "/$item"
		done
}

install_paru_git() {
  log "INFO" "Installing paru from git"
  # https://github.com/Morganamilo/paru
  local target_dir="$CLONE_DIR/Aur/paru"
  mkdir -p "$(dirname "$target_dir")"
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru.git "$target_dir"
  pushd "$target_dir" > /dev/null
  makepkg -si
  popd > /dev/null
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

# Main installation process
main() {
	sanity_checks
	copy_configs
	install_paru_git
	install_packages_pacman

	log "INFO" "Post install setup is complete, please reboot to continue"
}

# Run the installation
main
