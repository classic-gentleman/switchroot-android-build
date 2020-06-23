#!/bin/bash

echo lineage_$ROM_NAME-userdebug

cd /root/android/lineage
source build/envsetup.sh
export USE_CCACHE=1
ccache -M 50G
lunch lineage_$ROM_NAME-userdebug

sed -i '/BOARD_KERNEL_IMAGE_NAME := zImage/a BOARD_MKBOOTIMG_ARGS    += --cmdline " "' ~/android/lineage/device/nvidia/foster/BoardConfig.mk

NPROC=$(($(nproc) + 1))

if [ "$ROM_TYPE" == "zip" ]
  then
  make -j${NPROC} bacon
else
  make -j${NPROC} bootimage && make -j${NPROC} vendorimage && make -j${NPROC} systemimage && make -j${NPROC} recoveryimage
fi
