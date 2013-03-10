#include "workareajob.h"

#include "../qdbus/client/workareainterface.h"

WorkareaJob::WorkareaJob(const QString &id,
                                     const QString &operation,
                                     QMap<QString, QVariant> &parameters,
                                     WorkareaInterface *store,
                                     QObject *parent) :
    ServiceJob(parent->objectName(), operation, parameters, parent),
    m_id(id),
    m_store(store)
{
}

WorkareaJob::~WorkareaJob()
{
}

void WorkareaJob::start()
{
    const QString operation = operationName();    
    if(m_id == "Settings"){
        setResult(false);
        return;
    }

    if (operation == "addWorkarea") {

        QString name = parameters()["Name"].toString();

        if(m_store)
            m_store->AddWorkarea(m_id, name);

        setResult("name: " + name);
        return;
    }
    else if (operation == "removeWorkarea") {

        int desktop = parameters()["Desktop"].toInt();

        if(m_store)
            m_store->RemoveWorkarea(m_id, desktop);

        setResult("remove workarea: " + desktop);
        return;
    }
    else if (operation == "renameWorkarea") {

        QString name = parameters()["Name"].toString();
        int desktop = parameters()["Desktop"].toInt();

        if(m_store)
            m_store->RenameWorkarea(m_id, desktop, name);

        setResult("rename workarea: " + name);
        return;
    }
    else if (operation == "cloneWorkareas") {

        QString activity = parameters()["Activity"].toString();

        if(m_store)
            m_store->CloneActivity(m_id, activity);

        setResult("clone activity: " + activity);
        return;
    }
    else if (operation == "setOrder") {

        int order = parameters()["Order"].toInt();

        if(m_store)
            m_store->MoveActivity(m_id, order-1);

        setResult("activity order: " + QString::number(order));
        return;
    }
    else if (operation == "setCurrentNextActivity") {
        m_store->SetCurrentNextActivity();
        setResult("next activity... ");
        return;
    }
    else if (operation == "setCurrentPreviousActivity") {
        m_store->SetCurrentPreviousActivity();
        setResult("previous activity... ");
        return;
    }


    //m_id is needed for the rest
    if (m_id.isEmpty()) {
        setResult(false);
        return;
    }

    setResult(false);
}

#include "workareajob.moc"
