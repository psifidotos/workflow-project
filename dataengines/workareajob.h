#ifndef WORKAREAJOB_H
#define WORKAREAJOB_H

// plasma
#include <Plasma/ServiceJob>

namespace Workareas{
    class Store;
}

class WorkareaJob : public Plasma::ServiceJob
{
    Q_OBJECT

    public:
        WorkareaJob(const QString &id,
                          const QString &operation,
                          QMap<QString, QVariant> &parameters,
                          Workareas::Store *store,
                          QObject *parent = 0);
        ~WorkareaJob();

    protected:
        void start();

    private:
        QString m_id;
        Workareas::Store *m_store;
};

#endif
