#!/bin/bash
# Sets EXIF date from filename yymmdd_HHMMSS.jpg
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

    if ! [[ "$DATEPART" =~ ^[0-1][0-9]{5}_[0-9]{6}$ ]]; then
        echo "Not numeric: $DATEPART ($f)"
        continue
    fi

    YEAR="20${DATEPART:0:2}"
    MONTH=${DATEPART:2:2}
    DAY=${DATEPART:4:2}
    HOUR=${DATEPART:7:2}
    MINUTE=${DATEPART:9:2}
    SECOND=${DATEPART:11:2}

    DATE="$YEAR:$MONTH:$DAY $HOUR:$MINUTE:$SECOND"
    exiv2 mo -M "set Exif.Photo.DateTimeOriginal '$DATE'" -M "set Exif.Photo.DateTimeDigitized '$DATE'" $f
done
