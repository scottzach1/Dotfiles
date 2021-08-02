#!/bin/sh

if mullvad status | grep -q "Connected"; then
    echo ""
else
    echo ""
fi
