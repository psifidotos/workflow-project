# Project Needs a name ofcourse
project(plasma_applet_workflow)

set(NAME workflow)
set(VERSION 0.4.0)
set(AUTHOR "Michail Vourlakos")
set(EMAIL "psifidotos@users.sf.net")
set(WEBSITE "http://workflow.opentoolsandspace.org/")
set(ICON "preferences-activities")

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

add_subdirectory(qdbus)
add_subdirectory(components)
add_subdirectory(package)
add_subdirectory(dataengines)
add_subdirectory(po)
