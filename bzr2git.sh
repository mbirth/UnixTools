#!/bin/bash
PWD=`pwd`
DIRNAME=`basename "$PWD"`
if [ ! -d "$HOME/.bazaar/plugins/fastimport" ]; then
    echo "Fastimport plugin not found. Installing..."
    bzr branch lp:bzr-fastimport ~/.bazaar/plugins/fastimport
fi

echo "Processing: $DIRNAME"
if [ ! -d ".bzr" ]; then
    echo "No .bzr directory here. Is this a BZR branch?"
    exit 1
fi
if [ -d ".git" ]; then
    echo ".git already exists. Rename it and try again."
    exit 2
fi
echo "Creating git repo in $DIRNAME"
git init
echo "Ex-/Importing repository..."
bzr fast-export | git fast-import
echo "All done."
