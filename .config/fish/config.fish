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

# Sudo
abbr -a 's'  'sudo'
abbr -a 'sv' 'sudo nvim'

# Navigation
abbr -a '..'   'cd ../'
abbr -a '...'  'cd ../..'
abbr -a '....' 'cd ../../..'

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

# Git
abbr -a 'g'   'git'
abbr -a 'gs'  'git status'
abbr -a 'gp'  'git push'
abbr -a 'ga'  'git add'
abbr -a 'gc'  'git commit'
abbr -a 'gf'  'git fetch --all'
abbr -a 'gch' 'git checkout'
abbr -a 'gpu' 'git pull'

# Editor
abbr -a 'v' 'nvim'

# Music
abbr -a 'p'   'mpc toggle'
abbr -a 'n'   'mpc next'
abbr -a 'pr'  'mpc prev'
abbr -a 'mpc' 'status'
