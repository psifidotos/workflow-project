project(workareasengine)
# Find the required Libaries

set(workareas_engine_SRCS
        workareaengine.cpp
        workareajob.cpp
        workareaservice.cpp
        ../qdbus/client/storeinterface.cpp)

#add_subdirectory(workareas)

kde4_add_plugin(plasma_engine_workareas ${workareas_engine_SRCS})

target_link_libraries(plasma_engine_workareas
                      ${KACTIVITIES_LIBRARY}
                      ${KDE4_PLASMA_LIBS}
                      ${KDE4_KIO_LIBS}
                      ${KDE4_KFILE_LIBS}
                      taskmanager)


install(TARGETS plasma_engine_workareas
        DESTINATION ${PLUGIN_INSTALL_DIR})

install(FILES plasma-engine-workareas.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})

install(FILES workareas.operations
        DESTINATION ${DATA_INSTALL_DIR}/plasma/services)

