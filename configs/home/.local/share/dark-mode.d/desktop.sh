#!/bin/sh
# darkman dark-mode hook — flip the whole desktop to Catppuccin Mocha.
cfg="$HOME/.config"

# Hyprland reads the active darkman mode when its Lua config reloads.
hyprctl reload >/dev/null 2>&1

# Wallpaper
hyprctl hyprpaper wallpaper ",$HOME/.local/share/backgrounds/macos-big-sur-dark.jpg,cover" >/dev/null 2>&1

# waybar
cp "$cfg/waybar/colors-mocha.css" "$cfg/waybar/colors.css" 2>/dev/null && killall -SIGUSR2 waybar 2>/dev/null

# mako
cp "$cfg/mako/config-mocha" "$cfg/mako/config" 2>/dev/null && makoctl reload 2>/dev/null

# fuzzel (launched on demand — no reload needed)
cp "$cfg/fuzzel/fuzzel-mocha.ini" "$cfg/fuzzel/fuzzel.ini" 2>/dev/null

# kitty (live reload of every running instance)
cp "$cfg/kitty/theme-mocha.conf" "$cfg/kitty/current-theme.conf" 2>/dev/null
pkill -SIGUSR1 -x kitty 2>/dev/null

# ghostty follows the portal natively — nothing to do.

# GTK3 + libadwaita/GTK4 preference
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark-Catppuccin'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
fi
sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Colloid-Dark-Catppuccin/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
sed -i 's/^gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus-Dark/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
sed -i 's/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/' "$cfg/gtk-3.0/settings.ini" 2>/dev/null
