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

add_subdirectory(src)
add_subdirectory(po)

