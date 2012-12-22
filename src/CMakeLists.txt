# We add our source code here
set(workflow_SRCS workflow.cpp
                  storedparameters.cpp
                  activitymanager.cpp
                  ptaskmanager.cpp
                  plugins/pluginfindwallpaper.cpp
                  plugins/pluginshowwidgets.cpp
                  plugins/plugincloneactivity.cpp
                  plugins/pluginremoveactivity.cpp
                  plugins/pluginchangeworkarea.cpp
)

# Now make sure all files get to the right place
kde4_add_ui_files(workflow_SRCS config.ui)
kde4_add_kcfg_files(workflow_SRCS GENERATE_MOC workflowsettings.kcfgc)
kde4_add_plugin(plasma_applet_workflow ${workflow_SRCS})

target_link_libraries(plasma_applet_workflow
                      ${KDE4_PLASMA_LIBS}
                      ${X11_LIBRARIES}
                      ${KDE4_KDEUI_LIBS}
                      ${QT_QTDECLARATIVE_LIBRARY}
                      ${KDE4_KFILE_LIBS}
                      ${KACTIVITIES_LIBRARY}
                      taskmanager
)

install(TARGETS plasma_applet_workflow
        DESTINATION ${PLUGIN_INSTALL_DIR}
)
 
install(FILES workflow.kcfg
        DESTINATION ${KCFG_INSTALL_DIR}
)

add_subdirectory(package)
