#ifndef WORKAREAENGINE_H
#define WORKAREAENGINE_H

#include <QObject>

#include <Plasma/DataEngine>
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

    void workareaAddedSlot(QString,QString);
    void workareaRemovedSlot(QString,int);
    void workareaInfoUpdatedSlot(QString);

    void maxWorkareasChangedSlot(int);
private:
    Workareas::Store *m_store;
    //void insertDesktop(const int id, const QString activity);

    void loadActivity(QString);

};

#endif /*WORKAREAENGINE_H */
