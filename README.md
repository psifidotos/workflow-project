About
=====
This is the plasmoid version derived from the WorkFlow project. The project is
trying to enhance every user's unique workflow by combining existing technologies
from Plasma. 


Differences To Default KDe Workflow
===================================
-  Workareas use Virtual Desktops, in order to be consistent between them,
   Virtual Desktops are always that big as the maximum Workareas present from
   Activities.
   NOTICE: You can not add a Virtual Desktop when Workareas are running. You
   can add the Workarea needed and Virtual Desktops will be updated.

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

Requirements  
------------
kdebase4-workspace-devel >= 4.8  
libkdecore4-devel >= 4.8  
xorg-x11-libX11-devel  
libkactivities-devel >= 4.8  
libkde4-devel >= 4.8
