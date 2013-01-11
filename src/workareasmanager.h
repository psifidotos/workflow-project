#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>

class ActivitiesEnhancedModel;
class PluginUpdateWorkareasName;



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

    inline int maxWorkareas(){return m_maxWorkareas;}

signals:
    Q_INVOKABLE void workAreaWasClicked();
    void maxWorkareasChanged(int);

public slots:
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);
    void cloneWorkareas(QString, QString);

private slots:
    void setMaxWorkareas();
    void pluginUpdateWorkareasNameSlot(int);

protected:
    void init();

private:
    QHash <QString,QStringList *> m_storedWorkareas;

    int m_maxWorkareas;
    ActivitiesEnhancedModel *m_actModel;

    PluginUpdateWorkareasName *m_plgUpdateWorkareasName;

    bool activityExists(QString id);
    int activitySize(QString id);
    void addWorkareaInLoading(QString, QString);

    ///Workareas Storing/Accessing
    void loadWorkareas();
    void saveWorkareas();
};

#endif // WORKAREASMANAGER_H
