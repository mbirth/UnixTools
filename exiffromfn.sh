#!/bin/bash
# Sets EXIF date from filename yyyymmddHHMMSS.jpg
for f in *.jpg *.JPG; do
    if [ "$f" = "*.jpg" -o "$f" = "*.JPG" ]; then
        continue
    fi
    echo "File: $f"
    DATEPART=${f:0:14}
    if [ ${#DATEPART} -ne 14 ]; then
        echo "No date in filename: $f"
        continue
    fi

    if ! [[ "$DATEPART" =~ ^(198|199|200|201|202)[0-9]+$ ]]; then
        echo "Not numeric: $DATEPART ($f)"
        continue
    fi

    YEAR=${DATEPART:0:4}
    MONTH=${DATEPART:4:2}
    DAY=${DATEPART:6:2}
    HOUR=${DATEPART:8:2}
    MINUTE=${DATEPART:10:2}
    SECOND=${DATEPART:12:2}

    DATE="$YEAR:$MONTH:$DAY $HOUR:$MINUTE:$SECOND"

    exiv2 mo -M "set Exif.Photo.DateTimeOriginal '$DATE'" -M "set Exif.Photo.DateTimeDigitized '$DATE'" $f
done
