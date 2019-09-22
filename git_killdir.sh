#!/bin/sh

if [ -z "$1" ]; then
    echo "Syntax: $0 DIRECTORY_NAME"
    exit 1
fi

echo "This will erase the directory $1 from ALL commits ever made."
read -n 1 -s -r -p "Press any key to continue."

# https://stackoverflow.com/questions/10067848/remove-folder-and-its-contents-from-git-githubs-history
# esp. this answer: https://stackoverflow.com/a/32886427

# Create tracking branches of all branches
for remote in `git branch -r | grep -v /HEAD`; do git checkout --track $remote ; done

# Stats before
git count-objects -vH

# Remove DIRECTORY_NAME from all commits, then remove the refs to the old commits
# (repeat these two commands for as many directories that you want to remove)
git filter-branch --index-filter "git rm -rf --quiet --cached --ignore-unmatch $1/" --prune-empty --tag-name-filter cat -- --all
git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d

# Ensure all old refs are fully removed
rm -Rf .git/logs .git/refs/original

# Perform a garbage collection to remove commits with no refs
git gc --prune=all --aggressive

# Stats after
git count-objects -vH

echo "Now you can force-push the repository with:"
echo "\$ git push origin --all --force"
echo "\$ git push origin --tags --force"
