#include "workareasmanager.h"

#include <QHash>
#include <QDebug>
#include "../models/activitiesenhancedmodel.h"
#include "../models/workareaitem.h"
#include "../models/activityitem.h"
#include "../models/listmodel.h"

#include <taskmanager/task.h>

#include "workareas/store.h"
#include "workareas/info.h"

WorkareasManager::WorkareasManager(ActivitiesEnhancedModel *model,QObject *parent) :
    QObject(parent),
    m_maxWorkareas(0),
    m_actModel(model),
    m_store(0),
    m_activitiesLoadingFlag(false)
{
    m_store = new Workareas::Store(this);

    loadWorkareas();
    init();
}

WorkareasManager::~WorkareasManager()
{
    if(m_store)
        delete m_store;
}

void WorkareasManager::init()
{
    connect(m_store, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    //connect(m_store, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));
    connect(m_store, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)));
    connect(m_store, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)));
    connect(m_store, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

    connect(m_store, SIGNAL(maxWorkareasChanged(int)), this, SLOT(maxWorkareasChangedSlot(int)));

    m_store->initBackgrounds();
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

int WorkareasManager::numberOfWorkareas(QString actId)
{
    ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(actId));

    if (workareasModel)
        return workareasModel->getCount();

    return 0;
}



void WorkareasManager::addWorkArea(QString id, QString name)
{
    m_store->addWorkArea(id, name);
}

void WorkareasManager::renameWorkarea(QString id, int desktop, QString name)
{
    m_store->renameWorkarea(id, desktop, name);
}

void WorkareasManager::removeWorkarea(QString id, int desktop)
{
    m_store->removeWorkarea(id, desktop);
}

void WorkareasManager::setWallpaper(QString id, QString background)
{
    m_store->setBackground(id, background);
}


void WorkareasManager::addWorkareaInModel(QString id, QString name)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model)
        model->appendRow(new WorkareaItem(name,name,true,model));
}

void WorkareasManager::removeWorkareaInModel(QString id, int desktop)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model)
        model->removeRow(desktop-1);
}


void WorkareasManager::cloneWorkareas(QString from, QString to)
{
    m_store->cloneActivity(from, to);
}

void WorkareasManager::activityAddedSlot(QString id)
{
    //ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(id));

    if(m_store->activities().contains(id)){
        Workareas::Info *info = m_store->get(id);
        foreach(const QString &workarea, info->workareas())
            addWorkareaInModel(id, workarea);
    }
}

void WorkareasManager::activityRemovedSlot(QString id)
{
    Q_UNUSED(id);
    //The removal of activity in the model is done from the activitymanager
}

void WorkareasManager::workareaAddedSlot(QString id, QString name)
{
    addWorkareaInModel(id, name);
}

void WorkareasManager::workareaRemovedSlot(QString id, int desktop)
{
    removeWorkareaInModel(id, desktop);
}

void WorkareasManager::workareaInfoUpdatedSlot(QString id)
{
    ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(id));
    ActivityItem *activity = static_cast<ActivityItem *>(m_actModel->find(id));
    Workareas::Info *info = m_store->get(id);

    if(workareasModel && activity && info){
        //update background
        activity->setBackground(info->background());

        //update workareas
        int prevSize = workareasModel->getCount();
        int newSize = info->workareas().size();

        for(int i=0; i<newSize; ++i )
        {
            WorkareaItem *workarea = static_cast<WorkareaItem *>(workareasModel->at(i));

            if (i<prevSize)
                workarea->setTitle(info->workareas().at(i));
            else
                addWorkareaInModel(id, info->workareas().at(i));
        }

        if(prevSize > newSize)
            for(int j=newSize; j<prevSize; ++j )
                removeWorkareaInModel(id, j+1);
        //////

    }
}


void WorkareasManager::maxWorkareasChangedSlot(int size)
{
    if(m_maxWorkareas != size){
        m_maxWorkareas = size;
        emit maxWorkareasChanged(m_maxWorkareas);
    }
}


void WorkareasManager::loadWorkareas()
{
    QStringList activities = m_store->activities();

    foreach(const QString &activity, activities)
        activityAddedSlot(activity);
}

void WorkareasManager::setUpdateBackgrounds(bool active)
{
    if(m_store)
        m_store->setUpdateBackgrounds(active);
}



#include "workareasmanager.moc"
