About
=====
This is the plasmoid version derived from the WorkFlow project. The project is
trying to enhance every user's unique workflow by combining existing technologies
from Plasma. 

Installation
============
To build and install:

Automatic
---------
    sudo sh install.sh

Manual
------
    mkdir build && cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix`
    make
    sudo make install

Important Notice
---------
If you upgrade from previous versions then you must
make a restart in order for the workarea manager to start and
make the needed changes.
    
Upgrade
=========
Before you install version 0.4.0 and later you must
completely uninstall previous versions (0.2.x - 0.3.x)
If you had made an installation from source using the previous
steps then an easy way to uninstall is to enter the
build directory inside the plasmoid source directory and run:

    sudo make uninstall
    
Requirements  
------------
kdebase4-workspace-devel >= 4.9  
libkdecore4-devel >= 4.9  
xorg-x11-libX11-devel  
libkactivities-devel >= 4.9  
libkde4-devel >= 4.9