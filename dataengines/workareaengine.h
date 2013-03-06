#ifndef WORKAREAENGINE_H
#define WORKAREAENGINE_H

#include <QObject>
#include <QSignalMapper>

#include <Plasma/DataEngine>
#include <KActionCollection>

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
private:
    StoreInterface *m_store;
    //Workareas::Store *m_store;
    KActionCollection *actionCollection;
    //void insertDesktop(const int id, const QString activity);

    void loadActivity(QString);
    void updateOrders(QStringList);
};

#endif /*WORKAREAENGINE_H */
