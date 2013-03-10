project (WorkareaManager)

# General
# Find the required Libaries
# find_package(KDE4 REQUIRED)
# find_package(KActivities REQUIRED)

# Standard stuff
include_directories (
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_BINARY_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${KDE4_INCLUDES}
    )

set (workarea_manager_SRCS
    WorkareaManager.cpp
    workareainfo.cpp
    )

add_subdirectory (mechanism)

qt4_add_dbus_adaptor (
    workarea_manager_SRCS
    org.opentoolsandspace.WorkareaManager.xml
    WorkareaManager.h WorkareaManager
    workareamanageradaptor WorkareaManagerAdaptor
    )

kde4_add_kcfg_files(workarea_manager_SRCS GENERATE_MOC workareasdata.kcfgc)

kde4_add_plugin(kded_workareamanagerd ${workarea_manager_SRCS})

target_link_libraries (kded_workareamanagerd
    ${KACTIVITIES_LIBRARY}
    ${KDE4_KFILE_LIBS}
    )

########### install KDEDModule ###############

install (FILES
    workareamanagerd.desktop
    DESTINATION ${SERVICES_INSTALL_DIR}/kded
    )

install(TARGETS kded_workareamanagerd DESTINATION ${PLUGIN_INSTALL_DIR})

install(FILES org.opentoolsandspace.WorkareaManager.xml DESTINATION ${DBUS_INTERFACES_INSTALL_DIR} )


