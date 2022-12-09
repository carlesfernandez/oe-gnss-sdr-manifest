#!/bin/sh
# Push all branches to a repo
#
# Usage: ./push-to-repo.sh [remote]
#
# SPDX-FileCopyrightText: 2022 Carles Fernandez-Prades <cfernandez(at)cttc.es>
# SPDX-License-Identifier: MIT

version="1.0"
branches="master langdale kirkstone honister hardknott gatesgarth dunfell zeus warrior thud sumo rocko"

if ! [ -x "$(command -v git)" ]; then
    echo "Please install git before using this script."
    exit 1
fi

display_usage() {
    echo "push-to-repo.sh v$version - This script pushes all branches to a git repo."
    echo " Supported branches: $branches"
    echo " Usage:"
    echo "  ./push-to-repo.sh [remote]"
    echo "  where:"
    echo "   remote   Remote name (or full URL)"

}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    display_usage
    exit 0
fi

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "push-to-repo.sh v$version"
    exit 0
fi

remote=${1:-"https://github.com/carlesfernandez/oe-gnss-sdr-manifest"}
currentbranch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

if [ -z "$currentbranch" ]; then
    echo "We are not in a git repository. Exiting."
    exit 1
fi

git fetch "$remote" 2> /dev/null || echo "Remote $remote does not appear to be a git repository. Exiting." && exit 1

for branch in $branches; do
    git checkout "$branch" || echo "Branch $branch is not known to git. Exiting." && exit 1
    git push "$remote" "$branch" || echo "Something happened when pushing to $remote/$branch. Aborting." && exit 1
done

git checkout "$currentbranch"