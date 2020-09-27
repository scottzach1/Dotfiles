#!/bin/sh

if (mullvad status || true) | grep -q "Connected"; then
    echo ""
else
    echo ""
fi
