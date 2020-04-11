#                 _   _                 _     _
#   ___  ___ ___ | |_| |_ ______ _  ___| |__ / |
#  / __|/ __/ _ \| __| __|_  / _` |/ __| '_ \| |
#  \__ \ (_| (_) | |_| |_ / / (_| | (__| | | | |
#  |___/\___\___/ \__|\__/___\__,_|\___|_| |_|_|
#
#       Zac Scott (github.com/scottzach1)
#
# Fish Config

set editor "nvim"
set term "termite"

# No greeting when starting an interactive shell.
function fish_greeting
end

# Init Gnome keyring daemon.
if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end

# Navigation
alias ..='cd ../'
alias ...='cd ../../'

# Editor
alias v=nvim

# Music
alias p='mpc toggle'
alias n='mpc next'
alias pr='mpc prev'
alias s='mpc status'
