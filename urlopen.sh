#!/bin/bash
BROWSERS="x-www-browser opera firefox chromium-browser w3m epiphany-browser midori"
URL=`echo $1 | sed 's/&/&amp;/g'`
BROWSER=`zenity --list --title "Open URL" --text "Choose desired browser to open\n${URL}" --height 400 --column "Browser" ${BROWSERS}`
if [ -n "$BROWSER" ]; then
    case "$BROWSER" in
        chromium-browser)
            BROWSER="$BROWSER"
            ;;
        opera)
            BROWSER="$BROWSER -notrayicon -nomail -nolirc"
            ;;
    esac
    if [ -n "$1" ]; then
        BROWSER="$BROWSER $1"
    fi
    echo $BROWSER
    $BROWSER
fi
