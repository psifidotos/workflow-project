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
    explicit WorkflowManager(QObject *parent = 0);
    ~WorkflowManager();

   // ActivityManager *activityManager();
  //  WorkareasManager *workareaManager();
    //ActivitiesEnhancedModel *model();

    Q_INVOKABLE inline QObject *activityManager(){return ((QObject*)m_activityManager);}
    Q_INVOKABLE inline QObject *workareaManager(){return ((QObject*)m_workareaManager);}
    Q_INVOKABLE inline QObject *model(){return ((QObject*)m_model);}

protected:
    void init();

private:
    ActivityManager *m_activityManager;
    WorkareasManager *m_workareaManager;
    ActivitiesEnhancedModel *m_model;

    PluginSyncActivitiesWorkareas *m_plgSyncActivitiesWorkareas;
};




#endif
