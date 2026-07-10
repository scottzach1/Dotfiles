#!/bin/sh

if mullvad status | grep -q "Connected"; then
    echo " vpn connected"
else
    echo ""
fi
