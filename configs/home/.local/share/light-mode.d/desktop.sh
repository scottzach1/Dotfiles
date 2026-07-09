#!/bin/sh
# darkman light-mode hook — flip the whole desktop to Catppuccin Latte.
cfg="$HOME/.config"

# Hyprland border palette
cp "$cfg/hypr/theme-latte.conf" "$cfg/hypr/theme.conf" 2>/dev/null && hyprctl reload >/dev/null 2>&1

# waybar
cp "$cfg/waybar/colors-latte.css" "$cfg/waybar/colors.css" 2>/dev/null && killall -SIGUSR2 waybar 2>/dev/null

# mako
cp "$cfg/mako/config-latte" "$cfg/mako/config" 2>/dev/null && makoctl reload 2>/dev/null

# fuzzel (launched on demand — no reload needed)
cp "$cfg/fuzzel/fuzzel-latte.ini" "$cfg/fuzzel/fuzzel.ini" 2>/dev/null

# kitty (live reload of every running instance)
cp "$cfg/kitty/theme-latte.conf" "$cfg/kitty/current-theme.conf" 2>/dev/null
pkill -SIGUSR1 -x kitty 2>/dev/null

# ghostty follows the portal natively — nothing to do.

# GTK3 + libadwaita/GTK4 preference
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Light-Catppuccin'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
fi
sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Colloid-Light-Catppuccin/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
sed -i 's/^gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Light/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
sed -i 's/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=0/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
