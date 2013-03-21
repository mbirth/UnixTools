#!/bin/sh
INFILE="$1"
if [ ! -f "$1" ]; then
    echo "File ${INFILE} does not exist."
    exit 1
fi

TMPFILE=`tempfile -p pCB`

# This produces SSL style PHP

/opt/mbirth/phpCB \
--space-after-start-bracket \
--space-before-end-bracket \
--space-after-if \
--space-after-switch \
--space-after-while \
--space-before-start-angle-bracket \
--space-after-end-angle-bracket \
--extra-padding-for-case-statement \
--glue-amperscore \
--glue-arrow \
--change-shell-comment-to-double-slashes-comment \
--force-large-php-code-tag \
--align-equal-statements \
--comment-rendering-style PEAR \
--padding-char-count 4 \
--optimize-eol \
--one-true-brace \
--one-true-brace-function-declaration \
"$INFILE" > "$TMPFILE"
mv "$INFILE" "${INFILE}~"
mv "$TMPFILE" "$INFILE"

# more options:
# --indent-with-tab \
# --force-true-false-null-contant-lowercase \
# --remove-comments \
# --align-equal-statements-to-fixed-pos \
# --equal-align-position 50 \
# --comment-rendering-style PHPDoc \
