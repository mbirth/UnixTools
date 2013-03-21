#!/bin/bash
#cat hardlinked.lst | while read file; do
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: $file not found."
        continue
    fi
    echo -n "File: $file ... "
    mv "$file" "${file}-breaking"
    echo -n "Moved ..."
    cp "${file}-breaking" "$file"
    echo -n "Copied ..."
    rm "${file}-breaking"
    echo "Cleanup. DONE."
done
