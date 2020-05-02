#!/bin/sh

if ! mullvad status | grep -q 'Connect'; then
    echo " vpn disconnected"
else
    echo ""
fi
