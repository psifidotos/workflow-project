install(FILES 
	    ActivityDeleg.qml
	    ActivityStoppedDeleg.qml    
	    AllActTaskDeleg.qml
	    WorkAreaDeleg.qml
	    WorkAreaListDeleg.qml
	    WorkAreaOrphanTaskDeleg.qml
	    WorkAreaTaskDeleg.qml
        DESTINATION ${KDE4_DATA_INSTALL_DIR}/plasma-workflowplasmoid/qml/delegates)
        
add_subdirectory(ui-elements)
