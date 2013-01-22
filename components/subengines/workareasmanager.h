#ifndef WORKAREASMANAGER_H
#define WORKAREASMANAGER_H

#include <QHash>

class ActivitiesEnhancedModel;

namespace Workareas{
class Store;
}

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
    void maxWorkareasChanged(int);

public slots:
    //void activityAddedSlot(QString);
    void cloneWorkareas(QString, QString);

    //inline void activitiesLoadingSlot(bool flag){m_activitiesLoadingFlag = flag;}

protected:
    void init();


private slots:
    void activityAddedSlot(QString id);

    void workareaAddedSlot(QString id, QString name);
    void workareaRemovedSlot(QString id, int position);
    void workareaInfoUpdatedSlot(QString id);

    void maxWorkareasChangedSlot(int);

private:
    int m_maxWorkareas;
    ActivitiesEnhancedModel *m_actModel;
    Workareas::Store *m_store;

 //   bool activityExists(QString id);
    void addWorkareaInModel(QString, QString);
    void removeWorkareaInModel(QString id, int desktop);

    ///Workareas Storing/Accessing
    void loadWorkareas();

    bool m_activitiesLoadingFlag;
};

#endif // WORKAREASMANAGER_H
