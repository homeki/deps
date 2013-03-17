#!/bin/bash

# Halt on error
set -e

# Extract script paths
FULL_PATH=$(readlink -f $0)
BASE=`dirname $FULL_PATH`

function setup_prereqs() {
	echo "===== setting up prereqs ====="
	sudo apt-get install make cmake g++ ant
}

function build_owfs() {
	echo "===== owfs build started ====="
	sudo apt-get install fuse-utils libfuse-dev libusb-dev i2c-tools
	echo -n "Untaring: "
	pushd source > /dev/null
	tar -xzf ../tar/owfs*
	pushd owfs-2.9p0 > /dev/null
	echo "done"
	./configure -prefix /opt/owfs --disable-owhttpd --disable-owftpd --enable-cache --enable-owfs --enable-usb --enable-mt
	make -j3
	sudo make install
	popd > /dev/null
	popd > /dev/null
}

function build_telldus() {
	# if compile error in Socket_unix.cpp, add the include
	# <unistd.h>
	#
	# also make sure the universe ubuntu repo is enabled, required
	# for libconfuse0 and libconfuse-dev
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
	popd > /dev/null
	popd > /dev/null
}

# Change to base dir and create source dir
pushd $BASE > /dev/null
mkdir -p source

# Control what is built
#setup_prereqs
build_owfs
#build_telldus
