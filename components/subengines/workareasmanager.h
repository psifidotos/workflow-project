#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>
#include <Plasma/DataEngine>

class ActivitiesEnhancedModel;

class WorkareasManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int maxWorkareas READ maxWorkareas NOTIFY maxWorkareasChanged)

public:
    explicit WorkareasManager(ActivitiesEnhancedModel *, QObject *parent = 0);
    ~WorkareasManager();

    Q_INVOKABLE void addWorkArea(QString id, QString name);
    Q_INVOKABLE void removeWorkarea(QString id, int desktop);
    Q_INVOKABLE void renameWorkarea(QString id, int desktop, QString name);

    Q_INVOKABLE QString name(QString, int);
    Q_INVOKABLE int numberOfWorkareas(QString);

    //Q_INVOKABLE void setWallpaper(QString, QString);

    inline int maxWorkareas(){return m_maxWorkareas;}

signals:
    void maxWorkareasChanged(int);

public slots:
    void cloneWorkareas(QString, QString);

    void dataUpdated(QString source, Plasma::DataEngine::Data data);

protected:
    void init();

private slots:
    void activityAddedSlot(QString id);
    void activityRemovedSlot(QString id);

    void maxWorkareasChangedSlot(int);

private:
    int m_maxWorkareas;
    ActivitiesEnhancedModel *m_actModel;
    Plasma::DataEngine *m_dataEngine;

    void addWorkareaInModel(QString, QString);
    void removeWorkareaInModel(QString id, int desktop);

};

#endif // WORKAREASMANAGER_H
