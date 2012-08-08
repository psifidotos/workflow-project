
install(FILES 
	      Activities2.qml
	      ActivityAnimationMainView.qml
	      AllActivitiesTasks.qml
	      BtnIconAnimatMainView.qml
	      DraggingInterface.qml
	      MainAddActivityButton.qml
              ZoomSliderItem.qml
	      StoppedActivitiesPanel.qml
	      TaskAnimationMainView.qml
	      TitleMainView.qml
	      WorkAreasAllLists.qml

	      DynamicAnimations.js
        DESTINATION ${KDE4_DATA_INSTALL_DIR}/${CMAKE_PROJECT_NAME}/qml)
        
add_subdirectory(delegates)
add_subdirectory(helptour)
add_subdirectory(Images)
add_subdirectory(instances)
add_subdirectory(models)
add_subdirectory(ui)


