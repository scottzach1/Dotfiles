#!/bin/sh

if (mullvad status || true) | grep -q "Connecting"; then
    echo ""
else
    echo ""
fi
