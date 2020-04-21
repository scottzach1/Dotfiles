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
set term "alacritty"

# No greeting when starting an interactive shell.
function fish_greeting
end

# Init Gnome keyring daemon.
if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end

# Navigation
alias ..='cd ../'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
alias ll='ls -l'           # list files      
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls


# Interactive
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gp='git push'

# Editor
alias v=nvim

# Music
alias p='mpc toggle'
alias n='mpc next'
alias pr='mpc prev'
alias s='mpc status'
