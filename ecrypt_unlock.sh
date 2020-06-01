#!/bin/bash -u
#    $0 [ecryptfsdir [mountpoint]]
# Run as root with USER set to login user of ecryptfs
# https://bugs.launchpad.net/ubuntu/+source/ecryptfs-utils/+bug/455709
# https://ubuntuforums.org/showthread.php?p=10445371
# https://ubuntuforums.org/showthread.php?t=1508111
# -Ian! D. Allen - idallen@idallen.ca - www.idallen.com

if [ $(whoami) != 'root' ] ; then
    echo 1>&2 "$0: ERROR must be root to use this"
    exit 1
fi
USER=$SUDO_USER
if [ "$USER" = 'root' ] ; then
    echo 1>&2 "$0: Warning - USER is '$USER'"
fi

# source ecryptfs dir and desired mount point
#
if [ $# -gt 0 ] ; then
    DIR=$1
    shift
else
    # change this to where your keep your default encrypted backup
    DIR=/mnt/temporary/home/.ecryptfs/$USER
fi
if [ $# -gt 0 ] ; then
    MNT=$1
    shift
else
    # change this to your default backup mount point
    MNT=/mnt/temporary/home/$USER
fi
if [ $# -gt 0 ] ; then
    echo 1>&2 "$0: $#: more than two arguments: $*"
    exit 1
fi

# check that things exist and we can write them
if [ ! -d "$DIR" -o ! -r "$DIR" ]  ; then
    echo 1>&2 "$0: not a directory, or not readable: $DIR"
    exit 1
fi
if [ ! -d "$MNT" -o ! -w "$MNT" ]  ; then
    echo 1>&2 "$0: is not a writable directory: $MNT"
    exit 1
fi

pvt=$DIR/.Private
ecr=$DIR/.ecryptfs

if [ ! -d "$pvt" -o ! -r "$pvt" ]  ; then
    echo 1>&2 "$0: not a readable directory: $pvt"
    exit 1
fi
if [ ! -d "$ecr" -o ! -r "$ecr" ]  ; then
    echo 1>&2 "$0: not a readable directory: $ecr"
    exit 1
fi

privsig=$ecr/Private.sig
if [ ! -s "$privsig" -o ! -r "$privsig" ]  ; then
    echo 1>&2 "$0: not a non-null, readable signature file '$privsig'"
    exit 1
fi

sig1=$(head -n1 "$privsig") || exit $?
sig2=$(tail -n1 "$privsig") || exit $?
case "$sig1/$sig2" in
????????????????/???????????????? ) ;;
*)  echo 1>&2 "$0: Unable to extract signatures from '$privsig'"
    echo 1>&2 "$0: sig1: '$sig1'"
    echo 1>&2 "$0: sig2: '$sig2'"
    exit 1
    ;;
esac

read -s -p "$USER login password: " loginpass || exit $?
echo "" # add the missing newline after reading the password

# echo "DEBUG sig1 $sig1 and sig2 $sig2"
# keyctl clear @u
printf '%s\0' "$loginpass" | ecryptfs-insert-wrapped-passphrase-into-keyring "$ecr/wrapped-passphrase" - || exit $?
# keyctl list @u # DEBUG

# The -i bypasses the mount helper - see "man mount.ecryptfs"
#  ... but the "mount" man page claims this has a different function!
#  ... but it works for me (Ubuntu 10.10).  -IAN!
mount -i -t ecryptfs -o "ro,ecryptfs_passthrough=no,ecryptfs_unlink_sigs,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_sig=$sig1,ecryptfs_fnek_sig=$sig2" "$pvt" "$MNT" || exit $?
echo ""
df "$MNT"
