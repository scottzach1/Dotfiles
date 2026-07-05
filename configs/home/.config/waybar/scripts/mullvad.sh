#!/bin/sh
# Consolidates the three polybar mullvad scripts into one JSON status for
# waybar's custom module (class drives the colour in style.css).
status=$(mullvad status 2>/dev/null)

if echo "$status" | grep -q "Connected"; then
    echo '{"text":" vpn","class":"connected","tooltip":"Mullvad connected"}'
elif echo "$status" | grep -q "Connecting"; then
    echo '{"text":" vpn","class":"connecting","tooltip":"Mullvad connecting"}'
else
    echo '{"text":" off","class":"disconnected","tooltip":"Mullvad disconnected"}'
fi
