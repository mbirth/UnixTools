#!/bin/sh
gnome-screensaver-command -d
amixer -c 0 set Master Playback unmute
rhythmbox-client --no-start --play --no-present --notify
#MPC_SONG=`mpc current`
#if [ -n "$MPC_SONG" ]; then
#    mpc play
#fi
