#!/bin/bash

# first argument to this script is commit message

echo "Staging `pwd` for commit..."
git add .
git commit -m "$1"
# eval `ssh-agent -s`
# ssh-add ~/.ssh/passless_github_key
# git push