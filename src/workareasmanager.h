#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>

class ActivitiesEnhancedModel;

class WorkareasManager : public QObject
{
    Q_OBJECT
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

signals:
    void workAreaWasClicked();

public slots:

private:
    QHash <QString,QStringList *> m_storedWorkareas;

    ActivitiesEnhancedModel *m_actModel;
};

#endif // WORKAREASMANAGER_H
