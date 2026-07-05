#!/bin/sh
# Ported from polybar. Uses checkupdates (repo) + paru (AUR). Given the AUR
# supply-chain concerns driving this migration, repo updates are counted first
# and AUR is best-effort — swap `paru -Qua` out entirely if you drop the AUR.
repo=$(checkupdates 2>/dev/null | wc -l)
aur=$(paru -Qua 2>/dev/null | wc -l)
updates=$((repo + aur))

if [ "$updates" -gt 0 ]; then
    echo "  $updates updates"
else
    echo "  up to date"
fi
