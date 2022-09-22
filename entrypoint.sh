#!/bin/bash

set -eu

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "## Cleaning surrent working dir"

find . -delete

echo "## Initializing git repo..."
if [ ! -d .git ];
then git init
fi
git config --global --add safe.directory /github/workspace
echo "### Adding git remote..."
git remote add origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
echo "### Getting branch"
if [[ -v GITHUB_HEAD_REF && GITHUB_HEAD_REF -ne "" ]];
then
BRANCH=${GITHUB_HEAD_REF}
else
BRANCH=${GITHUB_REF_NAME}
fi
echo "### git fetch $BRANCH ..."
git pull origin $BRANCH
echo "### Branch: $BRANCH (ref: $GITHUB_REF )"
git checkout $BRANCH

git branch
git branch -a

echo "## Configuring git author..."
git config --global user.email "formabot@interieur.gouv.fr"
git config --global user.name "FormaBot"

# Ignore workflow files (we may not touch them)
git update-index --assume-unchanged .github/workflows/*

echo "## Running clang-format on C/C++ source"
SRC=$(git ls-tree --full-tree -r HEAD | grep -e "\.\(c\|h\|hpp\|cpp\)\$" | cut -f 2)

clang-format -style=file -i $SRC

echo "## Commiting files..."
git commit -a -m "apply clang-format" || true

git branch
git status

echo "## Pushing to $BRANCH"
git push -u origin $BRANCH
