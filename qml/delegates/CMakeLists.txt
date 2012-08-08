install(FILES 
	    ActivityDeleg.qml
	    ActivityStoppedDeleg.qml    
            TaskPreviewDeleg.qml
            TaskPreviewDelegAnimations.qml
	    WorkAreaDeleg.qml
	    WorkAreaListDeleg.qml
	    WorkAreaOrphanTaskDeleg.qml
	    WorkAreaTaskDeleg.qml
        DESTINATION ${KDE4_DATA_INSTALL_DIR}/${CMAKE_PROJECT_NAME}/qml/delegates)
        
add_subdirectory(ui-elements)
