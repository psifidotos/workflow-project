#ifndef WORKAREAENGINE_H
#define WORKAREAENGINE_H

#include <QObject>
#include <QSignalMapper>

#include <Plasma/DataEngine>
#include <KActionCollection>

namespace Workareas{
    class Store;
}


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

    void workareaAddedSlot(QString,QString);
    void workareaRemovedSlot(QString,int);
    void workareaInfoUpdatedSlot(QString);

    void activitiesOrderChangedSlot();

    void maxWorkareasChangedSlot(int);
private:
    Workareas::Store *m_store;
    KActionCollection *actionCollection;
    QSignalMapper * m_signalMapper;
    //void insertDesktop(const int id, const QString activity);

    void loadActivity(QString);
    void updateOrders();
};

#endif /*WORKAREAENGINE_H */
