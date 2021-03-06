#!/bin/bash
# \shellcheck configuration
# shellcheck disable=SC2162
# shellcheck disable=SC1091

readonly ghlink="https://raw.githubusercontent.com/Hakimi0804/realmeUI-debloater/main"
checkcon() {
    echo "checking connection"
    if ! ping -c 3 google.com >/dev/null 2>&1; then
        echo "no internet connection!"
        echo "cannot fetch package list and utility."
        exit 1
    fi
}
fetch-plist() {
    checkcon
    echo "fetching package list"
    curl -s "$ghlink/packagelist/gapps.txt -o gapps.txt"
    curl -s "$ghlink/packagelist/coloros.txt -o coloros.txt"
}
fetch-utils() {
    checkcon
    echo "fetching utils"
    mkdir -p linux-utils
    curl -s "$ghlink/linux-utils/bloat.sh -o bloat.sh"
    curl -s "$ghlink/linux-utils/misc.sh -o misc.sh"
    curl -s "$ghlink/linux-utils/colours.sh -o colours.sh"
}

if [ ! -f gapps.txt ] || [ ! -f coloros.txt ]; then
    fetch-plist
fi
if [ ! -f bloat.sh ] || [ ! -f misc.sh ]; then
    fetch-utils
fi

case $1 in
-r|--refresh)
    fetch-plist
    fetch-utils
    ;;
esac

# shelcheck source=linux-utils/colours.sh
# shellcheck source=linux-utils/bloat.sh
# shellcheck source=linux-utils/misc.sh
source bloat.sh
source misc.sh
source colours.sh
gapps_list="$(cat gapps.txt)"
coloros_bloat="$(cat coloros.txt)"

mainmenu() {
    clear
    mode=0
    echo "${bold_cyan}***********************************************************${cyan}"
    tput setaf 6
    echo "
                realme UI 1/2 debloater
                   by Hakimi0804
I am not responsible for any damage done to your device.    
    "
    tput sgr 0
    echo "${bold_cyan}***********************************************************${bold_white}"
    echo
    echo "$(tput setaf 7; tput bold)1 - light debloat"
    echo "2 - full debloat (not including gapps)"
    echo "3 - Google apps debloat"
    echo "4 - rebloat all debloated apps"
    echo "5 - check if adb is working"
    echo "6 - kill adb daemon"
    echo "7 - custom package"
    echo "8 - exit$(tput sgr 0)"
    
    read -p "${reset}Enter your choice: " mode
    
    case $mode in
    1)
        light
        ;;
    2)
        super
        ;;
    3)
        gapps
        ;;
    4)
        rebloat
        ;;
    5)
        checkadb
        ;;
    6)
        killadb
        ;;
    7)
        clear
        custom
        ;;
    8)
        clear
        echo "bye"
        exit
        ;;
    *)
        mainmenu
        ;;
esac
}

mainmenu
