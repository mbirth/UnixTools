#!/bin/sh
# needs: MP4Box

MP4Box -chap chapters.txt -out ${1}_chapters.mp4 $1
