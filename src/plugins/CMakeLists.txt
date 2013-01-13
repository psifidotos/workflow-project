# We add our source code here
set(workflow_SRCS
    ${workflow_SRCS}
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginfindwallpaper.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginshowwidgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/plugincloneactivity.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginremoveactivity.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginchangeworkarea.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginaddactivity.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginsyncactivitiesworkareas.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pluginupdateworkareasname.cpp
    PARENT_SCOPE
)
