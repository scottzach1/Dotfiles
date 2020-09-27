#!/bin/sh

if ! (mullvad status || true)| grep -q 'Connect'; then
    echo " "
else
    echo ""
fi
