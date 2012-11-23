#!/bin/bash
#Author: Michail Vourlakos
#Summary: Installation script for Workflow plasmoid
#05 Aug 2012
#This script was written and tested on openSuSe 12.1

if [[ -z "$BUILDDIR" ]] ; then
    BUILDDIR="build"
fi

mkdir -p $BUILDDIR || exit 1
cd $BUILDDIR || exit 1

echo
echo "*     Configure...        *"
echo
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` .. || exit 1

echo
echo "*    Compile...           *"
echo
make all || exit 1

echo
echo "*    Install...            *"
echo
if which sudo &>/dev/null; then
	sudo make install
else
	echo "Enter root password"
	su -c "make install"
fi

echo
echo "*    Cache refresh...     *"
echo
kbuildsycoca4

echo
echo "------ Installed -------------------------------"
echo
echo "*     Done. Place the plasmoid to your workplace!   *"
echo
