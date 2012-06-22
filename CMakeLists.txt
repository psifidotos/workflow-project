# Project Needs a name ofcourse
project(plasma-workflowplasmoid)
 
# Find the required Libaries
find_package(KDE4 REQUIRED)
include(KDE4Defaults)

 
add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
   ${CMAKE_SOURCE_DIR}
   ${CMAKE_BINARY_DIR}
   ${KDE4_INCLUDES}
   ${CMAKE_CURRENT_BINARY_DIR}
   )
 


# We add our source code here
set(workflow_SRCS workflow.cpp activitymanager.cpp ptaskmanager.cpp)
 
# Now make sure all files get to the right place

kde4_add_kcfg_files(workflow_SRCS GENERATE_MOC workflowsettings.kcfgc)
kde4_add_plugin(plasma_applet_workflow ${workflow_SRCS})

target_link_libraries(plasma_applet_workflow
                      plasma ${KDE4_PLASMA_LIBS}
                      ${X11_LIBRARIES}
                      ${KDE4_KDEUI_LIBS}
                      ${QT_QTDECLARATIVE_LIBRARY}
                      ${KDE4_KFILE_LIBS}
                      ${KACTIVITIES_LIBRARY}
                      taskmanager)


install(TARGETS plasma_applet_workflow
        DESTINATION ${PLUGIN_INSTALL_DIR})
 
install(FILES plasma-applet-workflow.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})

install(FILES workflow.kcfg
        DESTINATION ${KCFG_INSTALL_DIR})

add_subdirectory(qml)
