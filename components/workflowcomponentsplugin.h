#ifndef WORKFLOWCOMPONENTSPLUGIN_H
#define WORKFLOWCOMPONENTSPLUGIN_H

#include <QDeclarativeExtensionPlugin>

class WorkflowComponentsPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT

public:
    void registerTypes(const char *uri);
};

Q_EXPORT_PLUGIN2(workflowcomponentsplugin, WorkflowComponentsPlugin)

#endif
