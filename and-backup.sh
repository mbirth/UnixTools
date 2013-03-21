#!/bin/sh
ANDROID_SDK=/opt/android-sdk
if [ -z "$1" ]; then
    echo "Syntax: $0 PACKAGE"
    exit 1;
fi
$ANDROID_SDK/platform-tools/adb backup -f "$1.ab" -apk "$1"
