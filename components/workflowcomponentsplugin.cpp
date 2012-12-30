#include "workflowcomponentsplugin.h"

#include <QtDeclarative/qdeclarative.h>
#include "sessionparameters.h"
//#include "activitymanager.h"
//#include "icondialog.h"

void WorkflowComponentsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.workflow.components"));
    qmlRegisterType<SessionParameters>(uri, 0, 1, "SessionParameters");
    //qmlRegisterType<ActivityManager>(uri, 0, 1, "ActivityManager");
    //qmlRegisterType<IconDialog>(uri, 0, 1, "IconDialog");
}

#include "workflowcomponentsplugin.moc"
