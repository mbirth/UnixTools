#!/bin/bash
PWD=`pwd`
DIRNAME=`basename "$PWD"`
GITDIR="../$DIRNAME.GIT"
echo "Processing: $DIRNAME"
if [ ! -d ".bzr" ]; then
    echo "No .bzr directory here. Is this a BZR branch?"
    exit 1
fi
if [ -d "$GITDIR" ]; then
    echo "$GITDIR already exists. Rename it and try again."
    exit 2
fi
echo "Creating bzr-git repo in $GITDIR"
mkdir "$GITDIR"
bzr init --format=git "$GITDIR"
echo "Pushing revisions to $GITDIR"
bzr dpush "$GITDIR"
echo "cd'ing"
cd "$GITDIR"
echo "Fixing branch"
git branch master
git checkout master
echo "Resetting branch"
git reset --hard HEAD
echo "cd'ing back"
cd -
echo "All done."
