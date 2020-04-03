# No greeting when starting an interactive shell.
function fish_greeting
end

if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end
