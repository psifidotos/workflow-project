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
    Application.cpp
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

kde4_add_executable (workarea-manager ${workarea_manager_SRCS})

target_link_libraries (workarea-manager
    ${KDE4_KDEUI_LIBS}
    ${KACTIVITIES_LIBRARY}
    ${KDE4_KFILE_LIBS}
    )

#create executable
set_target_properties (workarea-manager
    PROPERTIES OUTPUT_NAME workareamanagerd
    )


########### install KDEDModule ###############

install (FILES workareamanagerd.desktop DESTINATION  ${AUTOSTART_INSTALL_DIR} )

#install (FILES org.opentoolsandspace.WorkareaManager.service DESTINATION  ${DBUS_SERVICES_INSTALL_DIR} )

install(TARGETS workarea-manager ${INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES org.opentoolsandspace.WorkareaManager.xml DESTINATION ${DBUS_INTERFACES_INSTALL_DIR} )

install(FILES workareas.kcfg DESTINATION ${KCFG_INSTALL_DIR})
