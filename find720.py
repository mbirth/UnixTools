#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
from pprint import pprint
import subprocess
import sys

VIDEO_EXTS = ["avi", "mp4", "mkv", "wmv", "mov", "m4v", "flv", "webm"]
MAX_HEIGHT = 720    # Only list videos with height (=shortest side) of more than this

# https://stackoverflow.com/questions/3844430/how-to-get-the-duration-of-a-video-in-python
def ffprobe(filepath):
    command = [
        "ffprobe",
        "-loglevel",  "quiet",
        "-print_format", "json",
        "-show_format",
        "-show_streams",
        filepath
    ]

    pipe = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    out, err = pipe.communicate()
    return json.loads(out)

def nice_size(bytesize):
    units = ["B", "K", "M", "G", "T"]
    bs = float(bytesize)
    u = 0
    while bs > 1200:
        bs = bs / 1024
        u += 1
    return "{:.2f}{}".format(bs, units[u])

large_vids = []

for root, dirs, files in os.walk("."):
    for f in files:
        ext = f.split(".")[-1]
        if not ext in VIDEO_EXTS:
            continue
        filepath = "{}/{}".format(root, f)
        meta = ffprobe(filepath)
        #pprint(meta)
        vmeta = None
        if not "streams" in meta:
            print("ERROR reading {}.".format(filepath), file=sys.stderr)
            continue
        for s in meta["streams"]:
            if s["codec_type"] == "video":
                vmeta = s
        if vmeta is None:
            print("No video stream found in {}.".format(filepath), file=sys.stderr)
            continue
        #pprint(vmeta)
        smaller = vmeta["height"]
        if vmeta["width"] < smaller:
            smaller = vmeta["width"]

        if smaller > MAX_HEIGHT:
            record = {
                "filepath": filepath,
                "width": vmeta["width"],
                "height": vmeta["height"],
                "filesize": meta["format"]["size"],
                "format": meta["codec_name"],
                "codec": meta["codec_tag_string"],
            }
            large_vids.append(record)
            print("+", end="", file=sys.stderr, flush=True)
        else:
            print(".", end="", file=sys.stderr, flush=True)

print(" done.", file=sys.stderr)

# Sort in descending order with largest file first
large_vids.sort(key=lambda x: int(x["filesize"]), reverse=True)

#pprint(large_vids)

for v in large_vids:
    print(v["filepath"])
    print("{:=4}x{:=4} {} {} {} ({})".format(v["width"], v["height"], v["codec"], nice_size(v["filesize"]), v["filepath"], v["format"]), file=sys.stderr)
