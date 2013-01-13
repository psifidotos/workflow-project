# We add our source code here

add_subdirectory(plugins)

set(components_SRCS
    ${components_SRCS}
    ${CMAKE_CURRENT_SOURCE_DIR}/activitymanager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/workareasmanager.cpp
    PARENT_SCOPE
)

