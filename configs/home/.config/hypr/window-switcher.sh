#!/bin/sh
# Window switcher for Hyprland via fuzzel — replaces `rofi -show window`.
sel=$(hyprctl clients -j \
  | jq -r '.[] | select(.mapped==true) | "\(.address)\t[\(.workspace.name)] \(.class) — \(.title)"' \
  | fuzzel --dmenu --width 80)
addr=$(printf '%s' "$sel" | cut -f1)
[ -n "$addr" ] && hyprctl dispatch focuswindow "address:$addr"
