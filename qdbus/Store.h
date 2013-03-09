#ifndef STORE_H
#define STORE_H

#include <QObject>
#include <QHash>
#include <QDBusContext>

#include <KDEDModule>
#include <KActivities/Controller>

class PluginUpdateWorkareasName;
class PluginSyncActivitiesWorkareas;
class PluginFindWallpaper;

class Info;

class Store : public KDEDModule,
              protected QDBusContext
{
    Q_OBJECT
//    Q_CLASSINFO("D-Bus Interface", "org.opentoolsandspace.WorkareaManager")

public:
    explicit Store(QObject* parent, const QList<QVariant>&);
    ~Store();

    void initBackgrounds();

public Q_SLOTS:
    Q_SCRIPTABLE void SetCurrentNextActivity();
    Q_SCRIPTABLE void SetCurrentPreviousActivity();

    Q_SCRIPTABLE void AddWorkarea(QString id, QString name);
    Q_SCRIPTABLE void RemoveWorkarea(QString id, int desktop);
    Q_SCRIPTABLE void RenameWorkarea(QString id, int desktop, QString name);
    //Only for the values contained in the workareas models
    Q_SCRIPTABLE void CloneActivity(QString, QString);
    Q_SCRIPTABLE void MoveActivity(QString, int);

    Q_SCRIPTABLE void SetUpdateBackgrounds(bool);

    Q_SCRIPTABLE int MaxWorkareas() const;
    Q_SCRIPTABLE QStringList Activities() const;
    Q_SCRIPTABLE QString ActivityBackground(QString actId);
    Q_SCRIPTABLE QStringList Workareas(QString actId);
    Q_SCRIPTABLE bool ServiceStatus();

Q_SIGNALS:
    void ActivityAdded(QString id);
    void ActivityRemoved(QString id);

    void WorkareaAdded(QString id, QStringList workareas);
    void WorkareaRemoved(QString id, QStringList workareas);
    void ActivityInfoUpdated(QString id, QString background, QStringList workareas);

    void ActivityOrdersChanged(QStringList activities);

    void MaxWorkareasChanged(int);
    void ServiceStatusChanged(bool);

private slots:
    void setBackground(QString, QString);
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);

    void workareaAddedSlot(QString id, QString name);
    void workareaRemovedSlot(QString id, int position);
    void workareaInfoUpdatedSlot(QString id);

    void pluginUpdateWorkareasNameSlot(int);

    void managerServiceRegistered();
    void onServiceStatusChanged (KActivities::Consumer::ServiceStatus status);

    //init thread
    void handleActivityReply();

protected:
    void initSignals();
    void initSession();

private:
  //  QHash <QString, Info *> m_workareasHash;
    QList <Info *> m_workareasList;

    KActivities::Controller *m_activitiesController;

    bool m_loading;
    int m_maxWorkareas;
    int m_nextDefaultWallpaper;
    QString m_service;
    bool m_isRunning;

    PluginUpdateWorkareasName *m_plgUpdateWorkareasName;
    PluginSyncActivitiesWorkareas *m_plgSyncActivitiesWorkareas;
    PluginFindWallpaper *m_plgFindWallpaper;

    ///Workareas Storing/Accessing
    void loadWorkareas();
    void saveWorkareas();
    void setMaxWorkareas();

    QString getNextDefWallpaper();
    QString nextRunningActivity();
    QString previousRunningActivity();
    bool connectToBus(const QString& service = QString(), const QString& path = QString());

    int findActivity(QString activityId);
    Info *get(QString);
    void createActivityChangedSignal(QString actId);
    //init thread
    void updateActivityList();
};

//}

#endif // STORE_H
