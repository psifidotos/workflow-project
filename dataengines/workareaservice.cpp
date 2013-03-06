#include "workareaservice.h"
#include "workareajob.h"

//#include "workareas/store.h"
#include "../qdbus/client/storeinterface.h"

WorkareaService::WorkareaService(const QString &source, StoreInterface *store)
      : m_id(source),
        m_store(store)
{
    setName("workareas");
}

ServiceJob *WorkareaService::createJob(const QString &operation, QMap<QString, QVariant> &parameters)
{
    return new WorkareaJob(m_id, operation, parameters, m_store, this);
}

#include "workareaservice.moc"
