# We add our source code here
set(workflow_SRCS
	${workflow_SRCS}
        ${CMAKE_CURRENT_SOURCE_DIR}/listitem.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/listmodel.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/activityitem.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/workareaitem.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/taskitem.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/activitiesenhancedmodel.cpp
        PARENT_SCOPE
)
