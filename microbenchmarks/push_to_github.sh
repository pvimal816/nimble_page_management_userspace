#!/bin/bash

# first argument to this script is commit message

git add .
git commit -m '$1'
eval `ssh-agent -s`
ssh-add ~/.ssh/passless_github_key
git push