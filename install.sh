#                 _   _                 _     _
#   ___  ___ ___ | |_| |_ ______ _  ___| |__ / |
#  / __|/ __/ _ \| __| __|_  / _` |/ __| '_ \| |
#  \__ \ (_| (_) | |_| |_ / / (_| | (__| | | | |
#  |___/\___\___/ \__|\__/___\__,_|\___|_| |_|_|
#
#       Zac Scott (github.com/scottzach1)
#
#  install.sh

xrdb -load ~/.config/X11/xresources

omf install https://github.com/scottzach1/dracula-theme-omf.git
omf theme dracula-theme-omf

# sudo cp 90-backlight.rules /etc/udev/rules.d
