set(workflow_plasmoid_dir ${DATA_INSTALL_DIR}/plasma/plasmoids/workflow)
set(metadata_dot_desktop ${CMAKE_CURRENT_BINARY_DIR}/metadata.desktop)

configure_file(metadata.desktop.cmake
    ${metadata_dot_desktop} @ONLY)

install(DIRECTORY contents
    DESTINATION ${workflow_plasmoid_dir}
    PATTERN ".*" EXCLUDE
    PATTERN "*~" EXCLUDE)

install(FILES ${metadata_dot_desktop}
    DESTINATION ${workflow_plasmoid_dir})

install(FILES ${metadata_dot_desktop}
    DESTINATION ${SERVICES_INSTALL_DIR} RENAME plasma-applet-workflow.desktop)
