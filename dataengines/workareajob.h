#ifndef WORKAREAJOB_H
#define WORKAREAJOB_H

// plasma
#include <Plasma/ServiceJob>

//namespace Workareas{
class StoreInterface;
//}

class WorkareaJob : public Plasma::ServiceJob
{
    Q_OBJECT

    public:
        WorkareaJob(const QString &id,
                          const QString &operation,
                          QMap<QString, QVariant> &parameters,
                          StoreInterface *store,
                          QObject *parent = 0);
        ~WorkareaJob();

    protected:
        void start();

    private:
        QString m_id;
        StoreInterface *m_store;
};

#endif
