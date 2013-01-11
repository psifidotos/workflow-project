#include "workareasmanager.h"

#include <QHash>
#include "workareasdata.h"
#include "models/activitiesenhancedmodel.h"
#include "models/workareaitem.h"
#include "models/listmodel.h"

#include <taskmanager/task.h>

#include "plugins/pluginupdateworkareasname.h"

WorkareasManager::WorkareasManager(ActivitiesEnhancedModel *model,QObject *parent) :
    QObject(parent),
    m_maxWorkareas(0),
    m_actModel(model),
    m_plgUpdateWorkareasName(0),
    m_activitiesLoadingFlag(false)
{
    loadWorkareas();
    init();
}

WorkareasManager::~WorkareasManager()
{
    saveWorkareas();

    //clear workareas QHash
    QHashIterator<QString, QStringList *> i(m_storedWorkareas);
    while (i.hasNext()) {
        i.next();
        QStringList *curWorks = i.value();
        if(curWorks){
            curWorks->clear();
            delete curWorks;
        }
    }
    m_storedWorkareas.clear();

    if(m_plgUpdateWorkareasName)
        delete m_plgUpdateWorkareasName;
}

void WorkareasManager::init()
{
    m_plgUpdateWorkareasName = new PluginUpdateWorkareasName(this);
    connect(m_plgUpdateWorkareasName, SIGNAL(updateWorkareasName(int)),
            this, SLOT(pluginUpdateWorkareasNameSlot(int)) );
}


void WorkareasManager::addWorkArea(QString id, QString name)
{
    QStringList *ret = m_storedWorkareas[id];

    if (ret){

        if(name==""){
            int counter = ret->size();
            name = TaskManager::TaskManager::self()->desktopName(counter+1);
        }

        ret->append(name);

        addWorkareaInLoading(id, name);
        m_plgUpdateWorkareasName->checkFlag(ret->size());
    }
}

void WorkareasManager::addWorkareaInLoading(QString id, QString name)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model)
        model->appendRow(new WorkareaItem(name,name,true,model));
}

QString WorkareasManager::name(QString id, int desktop)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model){
        WorkareaItem *workarea = static_cast<WorkareaItem *>(model->at(desktop-1));
        return workarea->title();
    }

    return "";
}


void WorkareasManager::renameWorkarea(QString id, int desktop, QString name)
{
    QStringList *ret = m_storedWorkareas[id];

    if (ret){
        if(name == "")
            name = TaskManager::TaskManager::self()->desktopName(desktop);

        ret->replace(desktop-1,name);
        ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
        if(model)
            model->setProperty(desktop-1,"title",name);
    }

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

    if (ret){
        ret->removeAt(desktop-1);

        ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
        if(model)
            model->removeRow(desktop-1);
    }
}

void WorkareasManager::cloneWorkareas(QString from, QString to)
{
    ListModel *modelFrom = static_cast<ListModel *>(m_actModel->workareas(from));
    ListModel *modelTo = static_cast<ListModel *>(m_actModel->workareas(to));
    QStringList *toAreas = m_storedWorkareas[to];

    if(modelFrom && modelTo && toAreas){
        modelTo->clear();
        toAreas->clear();   ///This must be replaced in the future, all the model
        ///will be stored in xml file without QStringLists in RAM
        ///only an xml DOM model should only exist if any

        for(int i=0; i<modelFrom->getCount(); i++){
            WorkareaItem *res = static_cast<WorkareaItem *>(modelFrom->at(i));
            if(res){
                modelTo->appendRow(res->copy(modelTo));
                toAreas->append(res->title());
            }
        }
    }
}

bool WorkareasManager::activityExists(QString id)
{
    return m_storedWorkareas.contains(id);
}


void WorkareasManager::setMaxWorkareas()
{
    if(!m_activitiesLoadingFlag){
        int prevmax = m_maxWorkareas;
        int max = 0;

        for(int i=0; i<m_actModel->getCount(); i++){
            ListItem *item = m_actModel->at(i);
            ListModel *workareas = static_cast<ListModel *>(m_actModel->workareas(item->id()));
            if(max<workareas->getCount())
                max = workareas->getCount();
        }


        if (max != prevmax){
            m_maxWorkareas = max;
            emit maxWorkareasChanged(m_maxWorkareas);
        }
    }
}


void WorkareasManager::activityAddedSlot(QString id)
{
    ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(id));

    if (workareasModel)
        connect(workareasModel, SIGNAL(countChanged(int)),
                this, SLOT(setMaxWorkareas()) );

    ///There is already a workareas record e.g. inloading the plasmoid
    if (activityExists(id)){
        QStringList *ret = m_storedWorkareas[id];

        for(int i=0; i<ret->size(); i++)
            addWorkareaInLoading(id,ret->value(i));
    }
    else{//a new activity is added, so the workareas records must be updated
        QStringList *newLst = new QStringList();
        m_storedWorkareas[id] = newLst;

        int numberOfDesktops = TaskManager::TaskManager::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            addWorkArea(id, "");
    }

}

void WorkareasManager::activityRemovedSlot(QString id)
{
    if (m_storedWorkareas.contains(id)){
        QStringList *ret = m_storedWorkareas[id];
        if(ret){
            ret->clear();
            delete ret;
        }

        m_storedWorkareas.remove(id);

    }
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
        if(curWorks){
            writeActivities.append(i.key());
            writeSizes.append(QString::number(curWorks->size()));

            for(int j=0; j<curWorks->size(); j++){
                writeWorkareas.append(curWorks->value(j));
            }
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

    int max = 0;

    for(int i=0; i<acts.size(); i++){
        QString activit = acts[i];

        int intpos = 0;
        for(int j=0; j<i; j++)
            intpos += lengths[j].toInt();

        QStringList *foundWorkAreas = new QStringList();

        for(int k=0; k<lengths[i].toInt(); k++)
            foundWorkAreas->append(wnames[intpos+k]);

        m_storedWorkareas[activit] = foundWorkAreas;

        if (foundWorkAreas->size() > max)
            max = foundWorkAreas->size();
    }

    m_maxWorkareas = max;
}


int WorkareasManager::numberOfWorkareas(QString actId)
{
    ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(actId));

    if (workareasModel)
        return workareasModel->getCount();

    return 0;
}

//PLUGINS

void WorkareasManager::pluginUpdateWorkareasNameSlot(int w_pos)
{
    for(int i=0; i<m_actModel->getCount(); i++)
    {
        ActivityItem *activity = static_cast<ActivityItem *>(m_actModel->at(i));
        ListModel *workareas = static_cast<ListModel *>(m_actModel->workareas(activity->id()));

        if (workareas->getCount() == w_pos)
            renameWorkarea(activity->id(), w_pos, "");
    }

}

#include "workareasmanager.moc"
