#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>

class WorkFlow;


class WorkareasManager : public QObject
{
    Q_OBJECT
public:
    explicit WorkareasManager(QObject *parent = 0);
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

signals:
    void workAreaWasClicked();

public slots:

private:
    QHash <QString,QStringList *> m_storedWorkareas;


};

#endif // WORKAREASMANAGER_H
