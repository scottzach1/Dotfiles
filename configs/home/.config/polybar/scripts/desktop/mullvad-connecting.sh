#!/bin/sh

if mullvad status | grep -q "Connecting"; then
    echo " vpn connecting"
else
    echo ""
fi
