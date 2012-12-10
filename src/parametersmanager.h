#ifndef PARAMETERSMANAGER_H
#define PARAMETERSMANAGER_H

#include <KConfigGroup>

class ParametersManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool lockActivities READ lockActivities WRITE setLockActivities NOTIFY lockActivitiesChanged)

public:
   explicit ParametersManager(QObject *parent = 0, KConfigGroup *conf = 0);
    ~ParametersManager();

    void setLockActivities(bool);
    bool lockActivities() const;

signals:
    void configNeedsSaving();
    void lockActivitiesChanged(bool);

private:
   KConfigGroup *config;

   bool m_lockActivities;

};


#endif
