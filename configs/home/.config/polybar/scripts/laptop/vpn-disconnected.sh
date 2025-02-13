#!/bin/sh

if ! mullvad status | grep -q 'Connect'; then
    echo " "
else
    echo ""
fi
