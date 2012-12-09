#include "componentsplugin.h"
#include <QtDeclarative/qdeclarative.h>
#include <activitymanager.h>

void ComponentsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.workflow.components"));
    qmlRegisterType<ActivityManager>(uri, 0, 1, "ActivityManager");
}

#include "componentsplugin.moc"
