#!/bin/sh
# needs: mkvtoolnix (for mkvmerge)
# chapters.txt:
# CHAPTER1=00:01:02.00
# CHAPTER1NAME=chapter 1
# ...
# CHAPTER23=01:02:03.00
# CHAPTER23NAME=chapter 23

mkvmerge --chapters chapters.txt -o ${1}_chapters.mkv $1
