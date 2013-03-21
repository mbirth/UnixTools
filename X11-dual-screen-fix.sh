#!/bin/sh
echo Switching position of displays
xrandr --output VGA-0 --right-of LVDS
echo Switching off ext. display
xrandr --output VGA-0 --off
echo Switching back to normal
xrandr --output VGA-0 --mode 1280x1024 --rate 75 --left-of LVDS
