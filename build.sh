#!/bin/bash

# Halt on error
set -e

# Extract script paths
FULL_PATH=$(readlink -f $0)
BASE=`dirname $FULL_PATH`

function build_owfs() {
	echo "===== owfs build started ====="
	sudo apt-get install fuse-utils libfuse-dev libusb-dev
	echo -n "Untaring: "
	pushd source > /dev/null
	tar -xzf ../tar/owfs*
	pushd owfs-2.8p14 > /dev/null
	echo "done"
	./configure -prefix /opt/owfs --disable-owhttpd --disable-owftpd --enable-cache --enable-owfs --enable-usb --enable-mt
	make -j3
	sudo make install
}

function build_telldus() {
	echo "===== telldus build started ====="
	sudo apt-get install libftdi1 libconfuse0 libconfuse-dev libftdi-dev
	echo -n "Untaring: "
	pushd source > /dev/null
	tar -xzf ../tar/telldus*
	pushd telldus-core-2.1.1 > /dev/null
	echo "done"
	cmake . -DCMAKE_INSTALL_PREFIX=/opt/telldus
	make
	sudo make install
}

# Change to base dir and create source dir
pushd $BASE > /dev/null
mkdir -p source

# Control what is built
#build_owfs
build_telldus
