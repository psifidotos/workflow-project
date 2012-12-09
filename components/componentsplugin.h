#ifndef COMPONENTSPLUGIN_H
#define COMPONENTSPLUGIN_H

#include <QDeclarativeExtensionPlugin>

class ComponentsPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT

public:
    void registerTypes(const char *uri);
};

Q_EXPORT_PLUGIN2(componentsplugin, ComponentsPlugin)

#endif
