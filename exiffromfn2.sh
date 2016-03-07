#!/bin/bash
# Sets EXIF date from filename yyyymmdd-HHMM.jpg
for f in *.jpg *.JPG; do
    if [ "$f" = "*.jpg" -o "$f" = "*.JPG" ]; then
        continue
    fi
    echo "File: $f"
    DATEPART=${f:0:13}
    if [ ${#DATEPART} -ne 13 ]; then
        echo "No date in filename: $f"
        continue
    fi

    if ! [[ "$DATEPART" =~ ^(198|199|200|201|202)[0-9]{5}-[0-9]{4}$ ]]; then
        echo "Not numeric: $DATEPART ($f)"
        continue
    fi

    YEAR=${DATEPART:0:4}
    MONTH=${DATEPART:4:2}
    DAY=${DATEPART:6:2}
    HOUR=${DATEPART:9:2}
    MINUTE=${DATEPART:11:2}
    SECOND="00"

    DATE="$YEAR:$MONTH:$DAY $HOUR:$MINUTE:$SECOND"
    exiv2 mo -M "set Exif.Photo.DateTimeOriginal '$DATE'" -M "set Exif.Photo.DateTimeDigitized '$DATE'" $f
done
