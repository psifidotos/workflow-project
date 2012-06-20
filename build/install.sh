#Author: Akos Toth(zuii)
#Summary: Installation script for BZFriendsPlasmoid
#2011 aug. 20
#!/bin/bash

echo "--- This script was written and tested on openSuSe 11.4 ---"

echo

echo "*     Configure...        *"

echo 
cmake -DCMAKE_INSTALL_PREFIX=`kde4-config --prefix` ..

echo

echo "*    Compile...           *"

echo 



make clean all

echo

echo "*    Install...            *"

echo 


sudo make install

echo

echo "*    Cache refresh...     *"

echo 


#kbuildsycoca4

echo
echo "------ Installed -------------------------------"




   echo
   echo "*     Done. Place the plasmoid to your workplace!   *"
   echo 

 
