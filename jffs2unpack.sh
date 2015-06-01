#!/bin/bash
# Needs mtd-tools with jffs2reader

if [ ! -f "$1" ]; then
    echo "Syntax: $0 JFFS2IMAGE"
    exit 1
fi

BASENAME=`basename "$1"`
OUTDIR="./${BASENAME}_unpack/"
mkdir $OUTDIR

while read -u3 line; do
#    echo "Line: $line"
    PERMS=`echo $line | cut -d" " -f1`
    SIZE=`echo $line | cut -d" " -f5`
    FILE=`echo $line | cut -d" " -f6`
    TYPE=${PERMS:0:1}
    PERMS=${PERMS:1}
#    echo "P:$PERMS S:$SIZE F:$FILE T:$TYPE"

    if [ "${FILE:0:1}" == "/" ]; then
        FILE=${FILE:1}
    fi

    PERMSU=`echo "${PERMS:0:3}" | sed 's/-//g'`
    PERMSG=`echo "${PERMS:3:3}" | sed 's/-//g'`
    PERMSO=`echo "${PERMS:6:3}" | sed 's/-//g'`

    FULLPERMS="u=$PERMSU,g=$PERMSG,o=$PERMSO"

    OUTFILE="$OUTDIR$FILE"

    case "$TYPE" in
        "d")
            OUTFILE="$OUTDIR$FILE"
            echo "DIR: $FILE ($FULLPERMS) --> $OUTFILE"
            mkdir "$OUTFILE"
            chmod $FULLPERMS "$OUTFILE"
            ;;

        "l")
            LINKTARGET=`echo $line | cut -d" " -f8`
            echo "Symlink: $FILE --> $LINKTARGET"
            ln -s $LINKTARGET "$OUTFILE"
            ;;

        "-")
            echo "FILE: $FILE ($SIZE bytes, $FULLPERMS)"
            jffs2reader "$1" -f "$FILE" > $OUTFILE
            chmod $FULLPERMS "$OUTFILE"
            ;;

        *)
            echo "UNKNOWN!!!!!!! ($line)"
            ;;
    esac

done 3< <(jffs2reader "$1")
