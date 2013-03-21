#!/bin/sh
RM="rm"
find -type d \( -name "__MACOSX" -or -name ".TemporaryItems" -or -name ".Spotlight-*" -or -name ".Trashes" -or -name ".fseventsd" \) -print -exec $RM -rf "{}" \;
find -type f \( -name ".DS_Store" -or -iname "Thumbs.db" -or -name "._*" -or -name ".fseventsd" -or -name ".VolumeIcon.icns" -or -name ".vbt5" \) -print -exec $RM -f "{}" \;

