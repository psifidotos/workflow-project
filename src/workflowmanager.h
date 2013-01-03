#ifndef WORKFLOWMANAGER_H
#define WORKFLOWMANAGER_H

#include <QObject>

class ActivityManager;
class WorkareasManager;
class ActivitiesEnhancedModel;

class PluginSyncActivitiesWorkareas;

class WorkflowManager : public QObject
{
    Q_OBJECT
public:
    explicit WorkflowManager(ActivitiesEnhancedModel *,QObject *parent = 0);
    ~WorkflowManager();

    ActivityManager *activityManager();
    WorkareasManager *workareasManager();
    ActivitiesEnhancedModel *model();

protected:
    void init();

private:
    ActivityManager *m_activityManager;
    WorkareasManager *m_workareasManager;
    ActivitiesEnhancedModel *m_model;

    PluginSyncActivitiesWorkareas *m_plgSyncActivitiesWorkareas;
};




#endif
