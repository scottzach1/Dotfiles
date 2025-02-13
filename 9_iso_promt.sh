#!/bin/bash

cryptsetup luksOpen /dev/nvme0n1p2 luks
mount /dev/vg0/root /mnt
swapon /dev/vg0/swap

arch-chroot /mnt
