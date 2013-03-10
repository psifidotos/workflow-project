#ifndef WORKAREAENGINE_H
#define WORKAREAENGINE_H

#include <QObject>

#include <Plasma/DataEngine>

class WorkareaInterface;
class QDBusPendingCallWatcher;

class WorkareaEngine : public Plasma::DataEngine
{
    Q_OBJECT
public:
    explicit WorkareaEngine(QObject *parent, const QVariantList& args);
    ~WorkareaEngine();

    Plasma::Service *serviceForSource(const QString &source);
    void init();
    void initSession();

private slots:
    void activityAddedSlot(QString id);
    void activityRemovedSlot(QString id);
    void nextActivitySlot();
    void previousActivitySlot();

    void workareaAddedSlot(QString, QStringList);
    void workareaRemovedSlot(QString, QStringList);
    void activityInfoUpdatedSlot(QString, QString, QStringList);

    void activitiesOrderChangedSlot(QStringList);

    void maxWorkareasChangedSlot(int);

    void onServiceRegistered(bool);
    //asychronous checking the service status in init
    void serviceCallFinishedSlot(QDBusPendingCallWatcher*);
private:
    WorkareaInterface *m_store;
    //void insertDesktop(const int id, const QString activity);

    void loadActivity(QString);
    void updateOrders(QStringList);
};

#endif /*WORKAREAENGINE_H */
