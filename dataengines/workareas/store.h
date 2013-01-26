#ifndef STORE_H
#define STORE_H

#include <QObject>
#include <QHash>

#include <KActivities/Controller>

class PluginUpdateWorkareasName;
class PluginSyncActivitiesWorkareas;
class PluginFindWallpaper;

namespace Workareas{
class Info;

class Store : public QObject
{
    Q_OBJECT

public:
    explicit Store(QObject *parent = 0);
    ~Store();

    void initBackgrounds();

    void addWorkarea(QString id, QString name);
    void removeWorkarea(QString id, int desktop);
    void renameWorkarea(QString id, int desktop, QString name);
    //Only for the values contained in the workareas models
    void cloneActivity(QString, QString);
    void moveActivity(QString, int);

    void setUpdateBackgrounds(bool);

    Workareas::Info *get(QString);
    int maxWorkareas() const;
    QStringList activities() const;   

public slots:
    void setBackground(QString, QString);

signals:
    void activityAdded(QString id);
    void activityRemoved(QString id);

    void workareaAdded(QString id, QString name);
    void workareaRemoved(QString id, int position);
    void workareaInfoUpdated(QString id);

    void activityOrdersChanged();

    void maxWorkareasChanged(int);

private slots:
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);

    void workareaAddedSlot(QString id, QString name);
    void workareaRemovedSlot(QString id, int position);
    void workareaInfoUpdatedSlot(QString id);

    void pluginUpdateWorkareasNameSlot(int);

protected:
    void init();

private:
  //  QHash <QString, Workareas::Info *> m_workareasHash;
    QList <Workareas::Info *> m_workareasList;

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
    int findActivity(QString activityId);
};

}

#endif // STORE_H
