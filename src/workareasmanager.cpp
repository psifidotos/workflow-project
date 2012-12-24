#include "workareasmanager.h"

#include <QHash>


#include "workareasdata.h"

WorkareasManager::WorkareasManager(QObject *parent) :
    QObject(parent)
{
    loadWorkareas();
}

WorkareasManager::~WorkareasManager()
{
    saveWorkareas();

    //clear workareas QHash
    QHashIterator<QString, QStringList *> i(m_storedWorkareas);
    while (i.hasNext()) {
        i.next();
        QStringList *curWorks = i.value();
        curWorks->clear();
        delete curWorks;
    }
    m_storedWorkareas.clear();

}


QStringList WorkareasManager::getWorkAreaNames(QString id)
{
    QStringList *ret = m_storedWorkareas[id];

    QStringList ret2;
    if(ret){
        for(int i=0; i<ret->size(); i++)
            ret2.append(ret->value(i));
    }
    return ret2;
}

void WorkareasManager::addWorkArea(QString id, QString name)
{
    QStringList *ret = m_storedWorkareas[id];

    if (ret)
        ret->append(name);
}

void WorkareasManager::addEmptyActivity(QString id)
{
    QStringList *newLst = new QStringList();
    m_storedWorkareas[id] = newLst;
}

void WorkareasManager::removeActivity(QString id)
{
    if (m_storedWorkareas.contains(id)){
        QStringList *ret = m_storedWorkareas[id];
        ret->clear();

        m_storedWorkareas.remove(id);
        delete ret;
    }
}

void WorkareasManager::renameWorkarea(QString id, int desktop, QString name)
{
    QStringList *ret = m_storedWorkareas[id];

    if (ret)
        ret->replace(desktop-1,name);
}

int WorkareasManager::activitySize(QString id)
{
    QStringList *ret = m_storedWorkareas[id];
    if (ret)
        return ret->size();
    else
        return 0;
}

void WorkareasManager::removeWorkarea(QString id, int desktop)
{
    QStringList *ret = m_storedWorkareas[id];

    if (ret)
        ret->removeAt(desktop-1);
}

bool WorkareasManager::activityExists(QString id)
{
    return m_storedWorkareas.contains(id);
}

void WorkareasManager::saveWorkareas()
{
    QHashIterator<QString, QStringList *> i(m_storedWorkareas);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        i.next();
        QStringList *curWorks = i.value();
        writeActivities.append(i.key());
        writeSizes.append(QString::number(curWorks->size()));

        for(int j=0; j<curWorks->size(); j++){
            writeWorkareas.append(curWorks->value(j));
        }
    }

    WorkareasData::setActivities(writeActivities);
    WorkareasData::setNoOfWorkareas(writeSizes);
    WorkareasData::setWorkareasNames(writeWorkareas);
    WorkareasData::self()->writeConfig();
}


void WorkareasManager::loadWorkareas()
{
    m_storedWorkareas.clear();

    QStringList acts = WorkareasData::activities();
    QStringList lengths = WorkareasData::noOfWorkareas();
    QStringList wnames = WorkareasData::workareasNames();

    for(int i=0; i<acts.size(); i++){
        QString activit = acts[i];

        int intpos = 0;
        for(int j=0; j<i; j++)
            intpos += lengths[j].toInt();

        QStringList *foundWorkAreas = new QStringList();

        for(int k=0; k<lengths[i].toInt(); k++)
            foundWorkAreas->append(wnames[intpos+k]);

        m_storedWorkareas[activit] = foundWorkAreas;
    }
}

void WorkareasManager::setWorkAreaWasClicked()
{
    emit workAreaWasClicked();
}


#include "workareasmanager.moc"
