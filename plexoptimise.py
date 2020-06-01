#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from collections import OrderedDict
from json import loads
from pprint import pprint
import subprocess
import sys

# Found: https://superuser.com/questions/852400/properly-downmix-5-1-to-stereo-using-ffmpeg
# and http://forum.doom9.org/showthread.php?t=168267
ATSC_MODE="pan=stereo|FL<1.0*FL+0.707*FC+0.707*BL|FR<1.0*FR+0.707*FC+0.707*BR"
NIGHT_MODE="pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR"
STEREO="pan=stereo|c0=FL|c1=FR"

FIRST_LANGUAGE="eng"      # first audio language
DEFAULT_LANGUAGE="eng"    # assume this language if not set in metadata
CRF="24"   # 18 - almost lossless, 22 - medium, 28 - low
KEEP_VIDEO=["h264"]

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
        return loads(out)

def add_video_params(params, out_idx, stream):
    if int(stream["height"]) > 720 or stream["codec_name"] != "h264":
        params["c:v"] = "h264"
        params["preset"] = "fast"
        params["crf"] = CRF
        # TODO: Might need some tweaking, not sure if it's really "mpeg4"
        if stream["codec_name"] == "mpeg4":
            params["bsf:v"] = "mpeg4_unpack_bframes"
        if int(stream["height"]) > 720:
            # Correct aspect ratio and rescale to 720
            params["filter_complex"].append("[0:{}]scale=iw*sar:ih,scale=-2:720,setsar=1:1".format(stream["index"]))
        else:
            # Just correct aspect ratio if needed
            params["filter_complex"].append("[0:{}]scale=iw*sar:ih,setsar=1:1".format(stream["index"]))
    else:
        params["filter_complex"].append("[0:{}]null".format(stream["index"]))
        params["c:v"] = "copy"
    params["movflags"] = "+faststart"
    if "field_order" in stream and stream["field_order"] != "progressive":
        fc = params["filter_complex"].pop()
        fc += ",yadif=1"   # 1 = use detected field_order, doubles framerate / 0 = merge both fields into frame, keeps framerate
        # To force field_order: 1:0 (top field first) or 1:1 (bottom field first) / -field-dominance 0 or -field-dominance 1
        params["filter_complex"].append(fc)
    # Force progressive: setfield=mode=prog

def add_audio_params(params, out_idx, stream):
    params["c:a"] = "aac"
    params["b:a"] = "96k"
    params["ar"] = "44100"
    params["ac"] = "2"
    if stream["channel_layout"] != "stereo":
        params["filter_complex"].append("[0:{}]{}".format(stream["index"], NIGHT_MODE))
    else:
        params["filter_complex"].append("[0:{}]{}".format(stream["index"], STEREO))
    params["metadata:s:{}".format(out_idx)] = "language={}".format(stream["tags"]["language"])

def add_sub_params(params, out_idx, stream):
    pass

def build_ffmpeg_cmd(params):
    cmd = ["nice", "ffmpeg", "-i", "\"{}\"".format(FILENAME)]
    for p, v in params.items():
        cmd.append("-{}".format(p))
        if p == "filter_complex":
            cmd.append("\"{}\"".format(";".join(v)))
        else:
            cmd.append(v)
    cmd.append("\"{}.mkv\"".format(FILENAME))
    return cmd

FILENAME = sys.argv[1]

data = ffprobe(FILENAME)
#pprint(data)

video_streams = []
audio_streams = []
other_streams = []
for s in data["streams"]:
    codec = s["codec_type"]
    if not "tags" in s:
        s["tags"] = {
            "language": DEFAULT_LANGUAGE
        }
    elif not "language" in s["tags"]:
        s["tags"]["language"] = DEFAULT_LANGUAGE
    if codec == "video":
        video_streams.append(s)
        print("Input #{}: Video {} {}x{}{}".format(
            s["index"],
            s["codec_name"],
            s["width"],
            s["height"],
            "p" if "field_order" not in s or s["field_order"] == "progressive" else "i"
        ))
    elif codec == "audio":
        audio_streams.append(s)
        print("Input #{}: Audio {} {}ch {} ({})".format(
            s["index"],
            s["codec_name"],
            s["channels"],
            s["channel_layout"],
            s["tags"]["language"]
        ))
    else:
        other_streams.append(s)
        print("Input #{}: Data {} {}".format(
            s["index"],
            s["codec_type"],
            s["codec_tag_string"]
        ))

# Make sure first audio is FIRST_LANGUAGE
if audio_streams[0]["tags"]["language"] != FIRST_LANGUAGE:
    for i, s in enumerate(audio_streams):
        if s["tags"]["language"] == FIRST_LANGUAGE:
            del audio_streams[i]
            audio_streams.insert(0, s)
            break

output_streams = video_streams + audio_streams + other_streams

# Now process streams in order to build command line
params = OrderedDict({
    "map": "0",
    "filter_complex": []
})
for i, s in enumerate(output_streams):
    codec = s["codec_type"]
    if codec == "video":
        add_video_params(params, i, s)
    elif codec == "audio":
        add_audio_params(params, i, s)
    elif codec == "subtitle":
        add_sub_params(params, i, s)
    else:
        print("Unknown codec_type: {}".format(codec))

cmd = build_ffmpeg_cmd(params)

#pprint(output_streams)
print(" ".join(cmd))
