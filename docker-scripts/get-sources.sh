#!/bin/bash

NPROC=$(($(nproc) - 1))

cd /root/android/lineage
repo init -u https://github.com/LineageOS/android.git -b lineage-16.0
repo sync -j${NPROC}

cd /root/android/lineage/.repo
git clone https://gitlab.com/switchroot/android/manifest.git local_manifests
repo sync -j${NPROC}
