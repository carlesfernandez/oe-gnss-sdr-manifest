#!/bin/sh
# Update all branches from upstream
#
# Usage: ./update-from-upstream.sh
#
# SPDX-FileCopyrightText: 2022 Carles Fernandez-Prades <cfernandez(at)cttc.es>
# SPDX-License-Identifier: MIT

branches="master langdale kirkstone honister hardknott gatesgarth dunfell zeus warrior thud sumo rocko"
upstream="https://github.com/carlesfernandez/oe-gnss-sdr-manifest"
currentbranch=$(git rev-parse --abbrev-ref HEAD)

git fetch $upstream
for branch in $branches; do
    git checkout "$branch"
    git pull $upstream "$branch"
done

git checkout "$currentbranch"