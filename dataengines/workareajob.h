#ifndef WORKAREAJOB_H
#define WORKAREAJOB_H

// plasma
#include <Plasma/ServiceJob>

class WorkareaInterface;

class WorkareaJob : public Plasma::ServiceJob
{
    Q_OBJECT

    public:
        WorkareaJob(const QString &id,
                          const QString &operation,
                          QMap<QString, QVariant> &parameters,
                          WorkareaInterface *store,
                          QObject *parent = 0);
        ~WorkareaJob();

    protected:
        void start();

    private:
        QString m_id;
        WorkareaInterface *m_store;
};

#endif
