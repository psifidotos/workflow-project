#ifndef WORKAREAENGINE_H
#define WORKAREAENGINE_H

#include <QObject>

#include <Plasma/DataEngine>

//namespace Workareas{
    class StoreInterface;
//}


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

    void managerServiceRegistered(bool);
private:
    StoreInterface *m_store;
    //void insertDesktop(const int id, const QString activity);

    void loadActivity(QString);
    void updateOrders(QStringList);
};

#endif /*WORKAREAENGINE_H */
