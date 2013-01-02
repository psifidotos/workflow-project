#ifndef WORKFLOWMANAGER_H
#define WORKFLOWMANAGER_H


class ActivityManager;
class WorkareasManager;
class ActivitiesEnhancedModel;

class WorkflowManager:public QObject
{
    Q_OBJECT
public:
    explicit WorkflowManager(QObject *parent = 0);
    ~WorkflowManager();

    ActivityManager *activityManager();
    WorkareasManager *workareasManager();
    ActivitiesEnhancedModel *model();
private:
    ActivityManager *m_activityManager;
    WorkareasManager *m_workareasManager;
    ActivitiesEnhancedModel *m_model;


};




#endif
