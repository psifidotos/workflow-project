project (WorkareaManager)

# General
# Find the required Libaries
find_package(KDE4 REQUIRED)
find_package(KActivities REQUIRED)
find_package(KDeclarative)

include(KDE4Defaults)

add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})

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
    Store.cpp
    info.cpp
    )

add_subdirectory (plugins)

kde4_add_kcfg_files(workarea_manager_SRCS GENERATE_MOC workareasdata.kcfgc)

qt4_add_dbus_adaptor (
    workarea_manager_SRCS
    org.opentoolsandspace.WorkareaManager.Store.xml
    Store.h Store
    )

kde4_add_executable (workarea-manager ${workarea_manager_SRCS})

target_link_libraries (workarea-manager
    ${KDE4_KDECORE_LIBS}
    ${KDE4_KDEUI_LIBS}   # KUniqueApplication
    ${KACTIVITIES_LIBRARY}
    ${KDE4_PLASMA_LIBS}
    ${KDE4_KIO_LIBS}
    ${KDE4_KFILE_LIBS}
    taskmanager
    ${ADDITIONAL_LINK_LIBS}
    )

set_target_properties (workarea-manager
    PROPERTIES OUTPUT_NAME workareamanagerd
    )

########### install application ###############

install (FILES
    workareamanagerd.desktop
    DESTINATION ${SERVICES_INSTALL_DIR}
    )

install (TARGETS
    workarea-manager ${INSTALL_TARGETS_DEFAULT_ARGS}
    )

install(FILES workareas.kcfg
        DESTINATION ${KCFG_INSTALL_DIR}
)
