#!/bin/sh
beep -f 1200 -d 50 -l 100 -r 3 -n -f 800 -l 100
amixer -c 0 set Master Playback mute
rhythmbox-client --no-start --pause
MPC_SONG=`mpc current`
if [ -n "$MPC_SONG" ]; then
    mpc pause
fi
motion >/dev/null 2>&1 &
gnome-screensaver-command -l
