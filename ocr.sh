#!/bin/sh
TMPFILE=`tempfile -p OCR -s ".txt"`
TMPBASE=`echo "$TMPFILE" | sed 's/\.txt//g'`
tesseract -l deu+eng "$1" "$TMPBASE"
cat "$TMPFILE"
rm "$TMPFILE"
