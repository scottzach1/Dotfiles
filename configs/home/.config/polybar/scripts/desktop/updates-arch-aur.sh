#!/bin/sh

if ! updates=$(yay -Qu 2> /dev/null | wc -l); then
    updates=0
fi

if [ "$updates" -gt 0 ]; then
    echo "  $updates updates"
else
    echo "  up to date"
fi
