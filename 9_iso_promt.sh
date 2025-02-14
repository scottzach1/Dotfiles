#!/bin/bash
#                 _   _                 _     _
#   ___  ___ ___ | |_| |_ ______ _  ___| |__ / |
#  / __|/ __/ _ \| __| __|_  / _` |/ __| '_ \| |
#  \__ \ (_| (_) | |_| |_ / / (_| | (__| | | | |
#  |___/\___\___/ \__|\__/___\__,_|\___|_| |_|_|
#
#       Zac Scott (github.com/scottzach1)
#
# 9_iso_prompt.sh

cryptsetup luksOpen /dev/nvme0n1p2 luks
mount /dev/vg0/root /mnt
swapon /dev/vg0/swap

arch-chroot /mnt
