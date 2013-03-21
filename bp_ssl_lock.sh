#!/bin/sh
amixer -c 0 set Master Playback mute
rhythmbox-client --no-start --pause
MPC_SONG=`mpc current`
if [ -n "$MPC_SONG" ]; then
    mpc pause
fi
gnome-screensaver-command -l
