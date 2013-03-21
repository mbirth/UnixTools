#!/bin/sh
gnome-screensaver-command -d
killall motion
amixer -c 0 set Master Playback unmute
rhythmbox-client --no-start --play --no-present --notify
MPC_SONG=`mpc current`
if [ -n "$MPC_SONG" ]; then
    mpc play
fi
beep -f 800 -d 50 -l 100 -r 3 -n -f 1200 -l 100
