#!/usr/bin/fish
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
set term "ghostty"

fish_add_path ~/.local/bin

set -x EDITOR /usr/bin/nvim
set -x BROWSER /usr/bin/firefox
set -x TERMINAL /usr/bin/ghostty
# Qt apps follow the qt5ct/qt6ct theme under Wayland (was the X11 gtk2 style plugin).
set -x QT_QPA_PLATFORMTHEME qt5ct

# No greeting when starting an interactive shell.
function fish_greeting
end

# NOTE: gnome-keyring is started once per graphical session from hypr/hyprland.conf
# (exec-once), not here — starting it from every shell was redundant.

# starship prompt (replaces the oh-my-fish dracula theme).
if status is-interactive
   and type -q starship
    starship init fish | source
end

# Sudo
abbr -a 's'  'sudo'
abbr -a 'sv' 'sudo nvim'

# Navigation
abbr -a 'q'    'exit'
abbr -a '..'   'cd ../'
abbr -a '...'  'cd ../..'
abbr -a '....' 'cd ../../..'

# Listing
abbr -a 'll' 'ls -l'         # list files      
abbr -a 'la' 'ls -Al'        # show hidden files
abbr -a 'lx' 'ls -lXB'       # sort by extension
abbr -a 'lk' 'ls -lSr'       # sort by size, biggest last
abbr -a 'lc' 'ls -ltcr'      # sort by and show change time, most recent last
abbr -a 'lu' 'ls -ltur'      # sort by and show access time, most recent last
abbr -a 'lt' 'ls -ltr'       # sort by date, most recent last
abbr -a 'lm' 'ls -al | more' # pipe through 'more'
abbr -a 'lr' 'ls -lR'        # recursive ls

# Git
abbr -a 'g'    'git'
abbr -a 'gs'   'git status'
abbr -a 'gp'   'git push'
abbr -a 'gpf'  'git push --force'
abbr -a 'ga'   'git add'
abbr -a 'gl'   'git log'
abbr -a 'gd'   'git diff'
abbr -a 'gb'   'git branch'
abbr -a 'gf'   'git fetch --all'
abbr -a 'gm'   'git merge'
abbr -a 'gc'   'git commit -m'
abbr -a 'gca'  'git commit --amend -m'
abbr -a 'gcl'  'git clone'
abbr -a 'gclr' 'git clone --recursive'
abbr -a 'gch'  'git checkout'
abbr -a 'gpu'  'git pull'
abbr -a 'gpur' 'git pull --rebase'
abbr -a 'gco'  'git config'
abbr -a 'gri'  'git rebase -i'
abbr -a 'grc'  'git rebase --continue'
abbr -a 'gpuuh' 'git pull origin master --allow-unrelated-histories'

# Misc
abbr -a 'pre' 'pre-commit run --all'
abbr -a 'tailnode' 'sudo tailscale status --peers --json | jq ".ExitNodeStatus"'

# Editor
abbr -a 'v' 'nvim'

# Music
abbr -a 'p'   'mpc toggle'
abbr -a 'n'   'mpc next'
abbr -a 'pr'  'mpc prev'
abbr -a 'ms'  'mpc status'

abbr -a 't'   'true'
abbr -a 'f'   'false'

# General configurations
set -x OP_BIOMETRIC_UNLOCK_ENABLED true
set -x CI_REGISTRY localhost:5000
set -x CI_REGISTRY_IMAGE localhost:5000
