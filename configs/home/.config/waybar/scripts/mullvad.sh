#!/bin/sh
# Mullvad status for waybar. 󰖂 = VPN (nf-md-vpn); class drives colour in style.css.
status=$(mullvad status 2>/dev/null)

if echo "$status" | grep -q "Connected"; then
    echo '{"text":"󰖂 on","class":"connected","tooltip":"Mullvad connected"}'
elif echo "$status" | grep -q "Connecting"; then
    echo '{"text":"󰖂 …","class":"connecting","tooltip":"Mullvad connecting"}'
else
    echo '{"text":"󰖂 off","class":"disconnected","tooltip":"Mullvad disconnected"}'
fi
