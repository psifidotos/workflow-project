#!/bin/bash
#Author: Michail Vourlakos
#Summary: Installation script for Workflow plasmoid
#05 Aug 2012
#This script was written and tested on openSuSe 12.1

echo
echo "*     Configure...        *"
echo
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..

echo
echo "*    Compile...           *"
echo
make all

echo
echo "*    Install...            *"
echo
if test -f /etc/debian_version; then
	echo "Enter root password"
	su -c "make install"
else
	sudo make install
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
