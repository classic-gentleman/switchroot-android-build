#!/bin/bash

NPROC=$(($(nproc) - 1))

cd /root/android/lineage
repo forall -c "bash -c 'git reset --hard \${1//*/\`git rev-list -1 --before=\${1} @\`}' null ${1}"

cd .repo/local_manifests
git pull

cd ../..

if [[ -z $1 ]]; then
    repo sync -j${NPROC}
fi
