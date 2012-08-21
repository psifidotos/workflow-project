# Project Needs a name ofcourse
project(plasma_applet_workflow)
 
# Find the required Libaries
find_package(KDE4 REQUIRED)
find_package(KActivities REQUIRED)

include(KDE4Defaults)

 
add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
   ${CMAKE_SOURCE_DIR}
   ${CMAKE_BINARY_DIR}
   ${KDE4_INCLUDES}
   ${CMAKE_CURRENT_BINARY_DIR}
   )
 


# We add our source code here
set(workflow_SRCS src/workflow.cpp src/activitymanager.cpp src/ptaskmanager.cpp)
 
# Now make sure all files get to the right place
kde4_add_ui_files(workflow_SRCS src/config.ui)
kde4_add_kcfg_files(workflow_SRCS GENERATE_MOC src/workflowsettings.kcfgc)
kde4_add_plugin(plasma_applet_workflow ${workflow_SRCS})

target_link_libraries(plasma_applet_workflow
                      ${KDE4_PLASMA_LIBS}
                      ${X11_LIBRARIES}
                      ${KDE4_KDEUI_LIBS}
                      ${QT_QTDECLARATIVE_LIBRARY}
                      ${KDE4_KFILE_LIBS}
                      ${KACTIVITIES_LIBRARY}
                      taskmanager)


install(TARGETS plasma_applet_workflow
        DESTINATION ${PLUGIN_INSTALL_DIR})
 
install(FILES plasma_applet_workflow.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})

install(FILES src/workflow.kcfg
        DESTINATION ${KCFG_INSTALL_DIR})

install(DIRECTORY src/package/contents/ 
        DESTINATION ${DATA_INSTALL_DIR}/${CMAKE_PROJECT_NAME}/qml
        PATTERN ".directory" EXCLUDE
        PATTERN ".fuse*" EXCLUDE
        )
        
add_subdirectory(po)
#add_subdirectory(src/package/contents)
