
install(FILES 
	      Activities2.qml
	      ActivityAnimationMainView.qml
	      AllActivitiesTasks.qml
	      BtnIconAnimatMainView.qml
	      DraggingInterface.qml
	      MainAddActivityButton.qml
	      ScrollBar.qml
	      Slider.qml
	      StoppedActivitiesPanel.qml
	      TaskAnimationMainView.qml
	      TitleMainView.qml
	      WorkAreasAllLists.qml
	      DynamicAnimations.js
        DESTINATION ${KDE4_DATA_INSTALL_DIR}/plasma-workflowplasmoid/qml)
        
add_subdirectory(ui)
add_subdirectory(models)
add_subdirectory(instances)
add_subdirectory(Images)
add_subdirectory(delegates)
