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
    Q_INVOKABLE void loadWorkareas();
    Q_INVOKABLE void saveWorkareas();
    Q_INVOKABLE QStringList getWorkAreaNames(QString);
    Q_INVOKABLE void addWorkArea(QString id, QString name);
    Q_INVOKABLE void addEmptyActivity(QString id);
    Q_INVOKABLE void removeActivity(QString id);
    Q_INVOKABLE bool activityExists(QString id);
    Q_INVOKABLE void renameWorkarea(QString id, int desktop, QString name);
    Q_INVOKABLE void removeWorkarea(QString id, int desktop);
    Q_INVOKABLE int activitySize(QString id);

    Q_INVOKABLE void setWorkAreaWasClicked();
    Q_INVOKABLE void addWorkareaInLoading(QString, QString);
    Q_INVOKABLE void cloneWorkareas(QString, QString);

    void init();

    inline int maxWorkareas(){return m_maxWorkareas;}

signals:
    void workAreaWasClicked();
    void maxWorkareasChanged(int);

private slots:
    void setMaxWorkareas();

private:
    QHash <QString,QStringList *> m_storedWorkareas;

    ActivitiesEnhancedModel *m_actModel;

    int m_maxWorkareas;


};

#endif // WORKAREASMANAGER_H
