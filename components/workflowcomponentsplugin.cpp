#include "workflowcomponentsplugin.h"

#include <QtDeclarative/qdeclarative.h>
#include "sessionparameters.h"
#include "workflowmanager.h"
#include "ptaskmanager.h"
#include "previewsmanager.h"
//#include "icondialog.h"

void WorkflowComponentsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.workflow.components"));
    qmlRegisterType<SessionParameters>(uri, 0, 1, "SessionParameters");
    qmlRegisterType<WorkflowManager>(uri, 0, 1, "WorkflowManager");
    qmlRegisterType<PTaskManager>(uri, 0, 1, "TaskManager");
    qmlRegisterType<PreviewsManager>(uri, 0, 1, "PreviewsManager");
    //qmlRegisterType<IconDialog>(uri, 0, 1, "IconDialog");
}

#include "workflowcomponentsplugin.moc"
