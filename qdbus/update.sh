#!/bin/sh
#create adaptor
qdbuscpp2xml -M -S WorkareaManager.h -o org.opentoolsandspace.WorkareaManager.xml
#create client access
cd client
qdbusxml2cpp -v -c WorkareaInterface -p workareainterface.h:workareainterface.cpp ../org.opentoolsandspace.WorkareaManager.xml
