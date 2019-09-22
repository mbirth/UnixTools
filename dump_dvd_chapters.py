#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pprint import pprint
import subprocess
import sys

def mplayer_ident(filepath):
    command = [
        "mplayer",
        "-identify",
        "-frames", "0",
        filepath
    ]
    pipe = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out, err = pipe.communicate()
    total_len = None
    chap = None
    #print(out.decode("utf-8"))
    for line in out.decode("utf-8").split("\n"):
        if "CHAPTERS:" in line:
            # TODO: Might appear multiple times
            chap = line[10:].strip(",").split(",")
        if "ID_DVD_TITLE_1_LENGTH" in line:
            (s, ms) = line[22:].strip().split(".")
            total_len = int(s) * 1000 + int(ms)
    return (total_len, chap)

def get_ms_from_hms(stamp):
    (h, m, s) = stamp.split(":")
    (s, ms) = s.split(".")
    result  = int(h) * 60 * 60 * 1000
    result += int(m) * 60 * 1000
    result += int(s) * 1000
    result += int(ms)
    return result

def print_ffmpeg_chaps(chapters, total_len):
    # https://ffmpeg.org/ffmpeg-formats.html#Metadata-1
    print(";FFMETADATA1")
    for i, c in enumerate(chapters):
        idx = i+1
        millis = get_ms_from_hms(c)
        next_c = total_len
        if i+1 < len(chapters):
            next_c = get_ms_from_hms(chapters[i+1])
        print("\n[CHAPTER]")
        print("TIMEBASE=1/1000")
        print("# START AT {}".format(c))
        print("START={:d}".format(millis))
        print("END={:d}".format(next_c))
        print("title=Chapter {:d}".format(idx))

def print_ogm_chaps(chapters):
    for i, c in enumerate(chapters):
        idx = i+1
        print("CHAPTER{:02d}={}".format(idx, c))
        print("CHAPTER{:02d}NAME=Chapter {:d}".format(idx, idx))

FILENAME = sys.argv[1]

(total_len, chaps) = mplayer_ident(FILENAME)

#pprint(chaps)

print_ffmpeg_chaps(chaps, total_len)
#print_ogm_chaps(chaps)
