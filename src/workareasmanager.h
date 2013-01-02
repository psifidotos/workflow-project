#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>

class ActivitiesEnhancedModel;

class WorkareasManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int maxWorkareas READ maxWorkareas NOTIFY maxWorkareasChanged)

public:
    explicit WorkareasManager(ActivitiesEnhancedModel *, QObject *parent = 0);
    ~WorkareasManager();

    ///Workareas Storing/Accessing
    void loadWorkareas();
    void saveWorkareas();


    Q_INVOKABLE void addWorkArea(QString id, QString name);

    Q_INVOKABLE void renameWorkarea(QString id, int desktop, QString name);
    Q_INVOKABLE void removeWorkarea(QString id, int desktop);

    Q_INVOKABLE void setWorkAreaWasClicked();
    Q_INVOKABLE void addWorkareaInLoading(QString, QString);

    Q_INVOKABLE QString name(QString, int);

    void init();

    inline int maxWorkareas(){return m_maxWorkareas;}

signals:
    void workAreaWasClicked();
    void maxWorkareasChanged(int);

public slots:
    void activityAddedSlot(QString);
    void activityRemovedSlot(QString);
    void cloneWorkareas(QString, QString);

private slots:
    void setMaxWorkareas();

private:
    QHash <QString,QStringList *> m_storedWorkareas;

    ActivitiesEnhancedModel *m_actModel;

    int m_maxWorkareas;

    bool activityExists(QString id);
    int activitySize(QString id);
};

#endif // WORKAREASMANAGER_H
