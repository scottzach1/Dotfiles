#!/bin/bash

# Configuration variables
TARGET_DISK="XXX"  # /dev/nvme0n1
SWAP_SIZE="32G"
HOSTNAME="desktop"
USERNAME="zaci"
TIMEZONE="Pacific/Auckland"
LOCALE="en_NZ.utf8"
KEYMAP="us"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Exit on any error and show commands being executed
set -e  # Exit immediately if a command exits with a non-zero status
set -x  # Print commands and their arguments as they are executed

# Set up logging
exec 1> >(tee "$(basename --suffix .sh "$0")_$(date +%Y%m%d_%H%M%S).log")
exec 2>&1

# Cleanup function
cleanup() {
    local exit_code=$?
    set +x  # Turn off command echoing for cleanup
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

# Helper function for logging
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

# Sanity checks
sanity_checks() {
    # Check if script is run as root
    if [ "$EUID" -ne 0 ]; then
        log "ERROR" "This script must be run as root"
        exit 1
    fi

    # Check if running in UEFI mode
    if [ ! -d "/sys/firmware/efi/efivars" ]; then
        log "ERROR" "System not booted in UEFI mode"
        exit 1
    fi

    # Check if target disk exists
    if [ ! -b "$TARGET_DISK" ]; then
        log "ERROR" "Target disk $TARGET_DISK not found"
        exit 1
    fi

    # Check if target disk is mounted
    if mount | grep -q "$TARGET_DISK"; then
        log "ERROR" "Target disk $TARGET_DISK is currently mounted. Please unmount first"
        exit 1
    fi

    # Check internet connectivity
    if ! ping -c 1 archlinux.org >/dev/null 2>&1; then
        log "ERROR" "No internet connection"
        exit 1
    fi

    log "INFO" "All sanity checks passed"
}


# Disk preparation
prepare_disk() {
    # Final warning before disk operations
    log "WARN" "This will erase all data on $TARGET_DISK"
    confirmation_prompt "Are you sure you want to continue?"

    # Create partition table and partitions
    log "INFO" "Wiping target disk"
    wipefs -a "$TARGET_DISK"
    parted -s "$TARGET_DISK" mklabel gpt
    parted -s "$TARGET_DISK" mkpart ESP fat32 1MiB 513MiB
    parted -s "$TARGET_DISK" set 1 boot on
    parted -s "$TARGET_DISK" mkpart primary ext4 513MiB 100%
    mapfile -t partitions < <(lsblk -ln -o NAME,TYPE | awk -v dev="$(basename "$TARGET_DISK")" '$2=="part" && $1 ~ dev {print "/dev/" $1}' | sort -V)
    partition_efi="${partitions[0]}"
    partition_luks="${partitions[1]}"

    log "WARN" "EFI Partition:  $partition_efi"
    log "WARN" "LUKS Partition: $partition_luks"
    confirmation_prompt "Does this look correct?"

    # Format EFI partition
    log "INFO" "Preparing EFI partition"
    mkfs.fat -F32 "$partition_efi"

    # Format luks partition
    log "INFO" "Preparing Luks partition"
    cryptsetup luksFormat "$partition_luks"
    cryptsetup luksOpen "$partition_luks" luks

    log "INFO" "Creating logical volumes"
    pvcreate /dev/mapper/luks
    vgcreate vg0 /dev/mapper/luks
    lvcreate -L "$SWAP_SIZE" vg0 --name swap
    lvcreate -l 100%FREE vg0 --name root
    mkfs.ext4 /dev/vg0/root
    mkswap /dev/vg0/swap

    log "INFO" "Mounting drives"
    mount /dev/vg0/root /mnt
    swapon /dev/vg0/swap
    mkdir -p /mnt/boot
    mount "$partition_efi" /mnt/boot
}

# Base system installation
install_base_system() {
    # Install base packages
    log "INFO" "Install base packages"
    # shellcheck disable=SC2046
    pacstrap /mnt $(cat packages-pacstrap.lst)

    # Generate fstab
    log "INFO" "Generate and update fstab"
    genfstab -U /mnt >> /mnt/etc/fstab

    # Reduce SSD wear (root partition only)
    sed -i '0,/relatime/s//noatime/' /mnt/etc/fstab

    # Add tmpfs entry for /tmp
    echo "# /tmp" >> /mnt/etc/fstab
    echo "tmpfs /tmp tmpfs rw,noatime,nodev,nosuid 0 0" >> /mnt/etc/fstab
}

# Run command in arch-chroot
chroot_cmd() {
  arch-chroot /mnt /bin/bash -c "$1"
}

# System configuration
configure_system() {
    # Set timezone
    log "INFO" "Set timezone to $TIMEZONE"
    chroot_cmd "ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime"
    chroot_cmd "hwclock --systohc"

    # Set locale
    log "INFO" "Set locale to $LOCALE"
    chroot_cmd locale-gen
    chroot_cmd "echo \"LANG=$LOCALE\" > /etc/locale.conf"

    # Set keyboard layout
    log "INFO" "Set keyboard layout to $KEYMAP"
    chroot_cmd "echo \"KEYMAP=$KEYMAP\" >> /etc/vconsole.conf"

    # Set hostname
    log "INFO" "Set hostname to $HOSTNAME"
    chroot_cmd "echo \"$HOSTNAME\" > /etc/hostname"

    # Add additional initramfs hooks (encrypt, lvm2, resume)
    log "INFO" "Add additional initramfs hooks (encrypt, lvm2, resume)"
    chroot_cmd "sed -i '/^HOOKS=/ s/filesystems/encrypt lvm2 filesystems resume/' /etc/mkinitcpio.conf"
    chroot_cmd "mkinitcpio -P"

    # Configure and install grub
    log "INFO" "Configure grub"
    mapfile -t partitions < <(lsblk -ln -o NAME,TYPE | awk -v dev="$(basename "$TARGET_DISK")" '$2=="part" && $1 ~ dev {print "/dev/" $1}' | sort -V)
    partition_luks="${partitions[1]}"
    chroot_cmd "sed -i 's|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"cryptdevice=${partition_luks}:luks:allow-discards resume=/dev/vg0/swap\"|' /etc/default/grub"
    chroot_cmd "sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub"
    chroot_cmd "sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub"
    chroot_cmd "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"
    chroot_cmd "grub-install --bootloader-id=Arch --efi-directory=/boot"
    chroot_cmd "grub-mkconfig -o /boot/grub/grub.cfg"

    # Set root password
    log "INFO" "Set password for root:"
    chroot_cmd "passwd"

    # Create user
    chroot_cmd "useradd -m -G wheel -s /usr/bin/fish $USERNAME"
    log "INFO" "Set password for $USERNAME:"
    chroot_cmd "passwd $USERNAME"

    # Configure sudo
    chroot_cmd "echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel"
}

# Main installation process
main() {
    sanity_checks
    prepare_disk
    install_base_system
    configure_system

    log "INFO" "Initial setup is complete"
    read -p "Would you like to reboot? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      log "INFO" "You may run the following you are done"
      log "INFO" "> umount -R /mnt; swapoff -a; reboot"
      log "INFO" "exiting gracefully..."
      exit 0
    fi
      log "INFO" "rebooting..."
      umount -R /mnt
      swapoff -a
      reboot
}

# Run the installation
main
