#!/bin/sh
echo Setting refresh rate to 75 Hz
xrandr --output VGA-0 --mode 1280x1024 --rate 75 --left-of LVDS
