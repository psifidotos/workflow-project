#include "workflowcomponentsplugin.h"

#include <QtDeclarative/qdeclarative.h>
#include "sessionparameters.h"
#include "workflowmanager.h"
#include "ptaskmanager.h"
#include "previewsmanager.h"
#include "environmentmanager.h"
#include "plasmoidwrapper.h"
#include "models/filtertaskmodel.h"
//#include "icondialog.h"

void WorkflowComponentsPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.workflow.components"));
    qmlRegisterType<SessionParameters>(uri, 0, 1, "SessionParameters");
    qmlRegisterType<WorkflowManager>(uri, 0, 1, "WorkflowManager");
    qmlRegisterType<PTaskManager>(uri, 0, 1, "TaskManager");
    qmlRegisterType<PreviewsManager>(uri, 0, 1, "PreviewsManager");
    qmlRegisterType<EnvironmentManager>(uri, 0, 1, "EnvironmentManager");
    qmlRegisterType<PlasmoidWrapper>(uri, 0, 1, "PlasmoidWrapper");
    qmlRegisterType<FilterTaskModel>(uri, 0, 1, "FilterTaskModel");
    //qmlRegisterType<IconDialog>(uri, 0, 1, "IconDialog");
}

#include "workflowcomponentsplugin.moc"
