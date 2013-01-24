# We add our source code here
add_subdirectory(plugins)
set(workareas_engine_SRCS
    ${workareas_engine_SRCS}
    ${CMAKE_CURRENT_SOURCE_DIR}/info.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/store.cpp
    PARENT_SCOPE
)

