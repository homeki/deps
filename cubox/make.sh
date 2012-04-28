#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
cd linux-3.3.1
make cubox_defconfig
#make menuconfig
#make uImage KALLSYMS_EXTRA_PASS=1
