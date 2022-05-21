#!/bin/sh

if mullvad status | grep -q "Connecting"; then
    echo ""
else
    echo ""
fi
