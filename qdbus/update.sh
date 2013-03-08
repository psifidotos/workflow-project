#!/bin/sh
#create adaptor
qdbuscpp2xml -M -S Store.h -o org.opentoolsandspace.WorkareaManager.xml
#create client access
cd client
qdbusxml2cpp -v -c StoreInterface -p storeinterface.h:storeinterface.cpp ../org.opentoolsandspace.WorkareaManager.xml
