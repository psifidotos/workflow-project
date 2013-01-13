project(workflowcomponents)

set(components_SRCS
    workflowcomponentsplugin.cpp
    sessionparameters.cpp
    workflowmanager.cpp
    ptaskmanager.cpp
    previewsmanager.cpp
#    icondialog.cpp
)

add_subdirectory(models)
add_subdirectory(subengines)

kde4_add_kcfg_files(components_SRCS GENERATE_MOC subengines/workareasdata.kcfgc)

#qt4_automoc(${components_SRCS})

include_directories(
    ${CMAKE_SOURCE_DIR}/internal
)

kde4_add_library(workflowcomponentsplugin SHARED ${components_SRCS})

target_link_libraries(workflowcomponentsplugin
        ${KACTIVITIES_LIBRARY}
        ${QT_QTCORE_LIBRARY}
        ${QT_QTDECLARATIVE_LIBRARY}
        ${KDE4_PLASMA_LIBS}
        ${KDE4_KIO_LIBS}
        ${KDE4_KFILE_LIBS}
        ${KDE4WORKSPACE_KWORKSPACE_LIBS}
        ${X11_LIBRARIES}
        taskmanager
)

install(TARGETS workflowcomponentsplugin DESTINATION ${IMPORTS_INSTALL_DIR}/org/kde/workflow/components)
install(DIRECTORY qml/
    DESTINATION ${IMPORTS_INSTALL_DIR}/org/kde/workflow/components
    PATTERN "*.qml"
    PATTERN "qmldir"
    PATTERN "*.js"
)

install(FILES subengines/workareas.kcfg
        DESTINATION ${KCFG_INSTALL_DIR}
)
