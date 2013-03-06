#ifndef STORE_H
#define STORE_H

#include <QObject>
#include <QHash>

#include <KActivities/Controller>

class PluginUpdateWorkareasName;
class PluginSyncActivitiesWorkareas;
class PluginFindWallpaper;

//namespace Workareas{
class Info;
//}

class Store : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.opentoolsandspace.WorkareaManager.Store")

public:
    explicit Store(QObject *parent = 0);
    ~Store();

    void initBackgrounds();

public Q_SLOTS:
    void SetCurrentNextActivity();
    void SetCurrentPreviousActivity();

    void AddWorkarea(QString id, QString name);
    void RemoveWorkarea(QString id, int desktop);
    void RenameWorkarea(QString id, int desktop, QString name);
    //Only for the values contained in the workareas models
    void CloneActivity(QString, QString);
    void MoveActivity(QString, int);

    void SetUpdateBackgrounds(bool);

    int MaxWorkareas() const;
    QStringList Activities() const;
    QString ActivityBackground(QString actId);
    QStringList Workareas(QString actId);

Q_SIGNALS:
    void ActivityAdded(QString id);
    void ActivityRemoved(QString id);

    void WorkareaAdded(QString id, QStringList workareas);
    void WorkareaRemoved(QString id, QStringList workareas);
    void ActivityInfoUpdated(QString id, QString background, QStringList workareas);

    void ActivityOrdersChanged(QStringList activities);

    void MaxWorkareasChanged(int);

private slots:
    void setBackground(QString, QString);
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);

    void workareaAddedSlot(QString id, QString name);
    void workareaRemovedSlot(QString id, int position);
    void workareaInfoUpdatedSlot(QString id);

    void pluginUpdateWorkareasNameSlot(int);

protected:
    void init();

private:
  //  QHash <QString, Info *> m_workareasHash;
    QList <Info *> m_workareasList;

    KActivities::Controller *m_activitiesController;

    bool m_loading;
    int m_maxWorkareas;
    int m_nextDefaultWallpaper;

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
    int findActivity(QString activityId);
    Info *get(QString);
    void createActivityChangedSignal(QString actId);
};

//}

#endif // STORE_H
