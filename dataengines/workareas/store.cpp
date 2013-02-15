#include "store.h"

#include <QDebug>
#include <QList>

#include <KActivities/Controller>
#include <KActivities/Info>

#include "workareasdata.h"
#include <taskmanager/task.h>
#include "plugins/pluginupdateworkareasname.h"
#include "plugins/pluginsyncactivitiesworkareas.h"
#include "plugins/pluginfindwallpaper.h"

#include "info.h"

namespace Workareas{

Store::Store(QObject *parent) :
    QObject(parent),
    m_activitiesController(new KActivities::Controller(this)),
    m_loading(false),
    m_maxWorkareas(0),
    m_nextDefaultWallpaper(0),
    m_plgUpdateWorkareasName(0),
    m_plgSyncActivitiesWorkareas(0),
    m_plgFindWallpaper(0)
{
    init();

    loadWorkareas();
}

Store::~Store()
{
    saveWorkareas();

    QListIterator<Workareas::Info *> i(m_workareasList);

    while (i.hasNext()) {
        Workareas::Info *curWorks = i.next();
        if(curWorks)
            delete curWorks;
    }

    m_workareasList.clear();

    if(m_plgUpdateWorkareasName)
        delete m_plgUpdateWorkareasName;

    if(m_plgSyncActivitiesWorkareas)
        delete m_plgSyncActivitiesWorkareas;

    if(m_plgFindWallpaper)
        delete m_plgFindWallpaper;
}

void Store::init()
{
    connect(m_activitiesController, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesController, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));

    m_plgSyncActivitiesWorkareas = new PluginSyncActivitiesWorkareas(this);
    connect(this, SIGNAL(maxWorkareasChanged(int)),
            m_plgSyncActivitiesWorkareas, SLOT(maxWorkareasUpdated(int)) );

    m_plgUpdateWorkareasName = new PluginUpdateWorkareasName(this);
    connect(m_plgUpdateWorkareasName, SIGNAL(updateWorkareasName(int)),
            this, SLOT(pluginUpdateWorkareasNameSlot(int)) );

    m_plgFindWallpaper = new PluginFindWallpaper(m_activitiesController, this);
    connect(m_plgFindWallpaper, SIGNAL(updateWallpaper(QString,QString)), this, SLOT(setBackground(QString,QString)));
}

void Store::initBackgrounds()
{
    m_plgFindWallpaper->initBackgrounds();
}


Workareas::Info *Store::get(QString id)
{
    int pos = findActivity(id);
    return ((Workareas::Info *)m_workareasList[pos]);
}

int Store::maxWorkareas() const
{
    return m_maxWorkareas;
}

QStringList Store::activities() const
{
    QStringList result;

    QListIterator<Workareas::Info *> i(m_workareasList);

    while (i.hasNext()) {
        Workareas::Info *info = i.next();
        result.append(info->id());
    }

    return result;
}

void Store::addWorkarea(QString id, QString name)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Workareas::Info *info = m_workareasList[pos];

        if(name==""){
            int counter = info->m_workareas.size();
            name = TaskManager::TaskManager::self()->desktopName(counter+1);
        }

        info->addWorkArea(name);

        // m_plgUpdateWorkareasName->checkFlag(info->m_workareas.size());
    }
}

void Store::renameWorkarea(QString id, int desktop, QString name)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Workareas::Info *info = m_workareasList[pos];
        if(name == ""){
            name = TaskManager::TaskManager::self()->desktopName(desktop);
        }

        info->renameWorkarea(desktop, name);
    }

}

void Store::removeWorkarea(QString id, int desktop)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Workareas::Info *info = m_workareasList[pos];
        info->removeWorkarea(desktop);
    }
}


void Store::cloneActivity(QString from, QString to)
{
    int posFrom = findActivity(from);
    int posTo = findActivity(to);

    Workareas::Info *infoFrom = 0;
    Workareas::Info *infoTo = 0;

    if (posFrom>=0 && posFrom<m_workareasList.size()){
        infoFrom = m_workareasList[posFrom];
    }

    //The signal to clone comes earlier than the activityAdded one
    if (posTo<0 || posTo>=m_workareasList.size()){
        activityAddedSlot(to);
        posTo = findActivity(to);
        infoTo = m_workareasList[posTo];
    }

    if(infoFrom && infoTo){
        Workareas::Info *copy = infoFrom->copy(this);
        copy->m_id = infoTo->m_id;

        disconnect( m_workareasList[posTo], SIGNAL(workareaAdded(QString,QString)) );
        disconnect( m_workareasList[posTo], SIGNAL(workareaRemoved(QString,int)) );
        disconnect( m_workareasList[posTo], SIGNAL(workareaInfoUpdated(QString)) );

        m_workareasList.removeAt(posTo);

        connect(copy, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(copy, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(copy, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        m_workareasList.append(copy);

        workareaInfoUpdatedSlot(to);
    }

}

void Store::moveActivity(QString id, int toPosition)
{
    int fromPosition = findActivity(id);

    if (toPosition>=m_workareasList.size())
        toPosition = m_workareasList.size()-1;

    if (toPosition>=0 && toPosition<m_workareasList.size() &&
            fromPosition>=0 && fromPosition<m_workareasList.size() &&
            fromPosition != toPosition){
        m_workareasList.move(fromPosition, toPosition);
        saveWorkareas();
        emit activityOrdersChanged();
    }
}

void Store::setBackground(QString id, QString background)
{
    int pos = findActivity(id);

    if(pos>=0 && pos<m_workareasList.size() ){
        Workareas::Info *info = m_workareasList[pos];
        if (background != "")
            info->setBackground(background);
        else
            info->setBackground(getNextDefWallpaper());
    }
}


void Store::activityAddedSlot(QString id)
{
    int pos = findActivity(id);

    if(pos<0 || pos>=m_workareasList.size() ){
        Workareas::Info *info = new Workareas::Info(id, this);

        int numberOfDesktops = TaskManager::TaskManager::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            info->addWorkArea(TaskManager::TaskManager::self()->desktopName(j+1));

        m_workareasList.append(info);
        //m_workareasHash[id] = info;

        connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        saveWorkareas();
        emit activityAdded(id);
        setMaxWorkareas();
    }
}

void Store::activityRemovedSlot(QString id)
{
    int pos = findActivity(id);

    if(pos>=0 || pos<m_workareasList.size() ){
        disconnect( m_workareasList[pos], SIGNAL(workareaAdded(QString,QString)) );
        disconnect( m_workareasList[pos], SIGNAL(workareaRemoved(QString,int)) );
        disconnect( m_workareasList[pos], SIGNAL(workareaInfoUpdated(QString)) );

        m_workareasList.removeAt(pos);

        saveWorkareas();
        emit activityRemoved(id);
        setMaxWorkareas();
    }
}

void Store::workareaAddedSlot(QString id, QString name)
{
    saveWorkareas();
    emit workareaAdded(id, name);
    setMaxWorkareas();
}

void Store::workareaRemovedSlot(QString id, int position)
{
    saveWorkareas();
    emit workareaRemoved(id, position);
    setMaxWorkareas();
}

void Store::workareaInfoUpdatedSlot(QString id)
{
    saveWorkareas();
    emit workareaInfoUpdated(id);
}

void Store::setCurrentNextActivity()
{
    QString nId = nextRunningActivity();

    if(nId != "")
        m_activitiesController->setCurrentActivity(nId);
}

void Store::setCurrentPreviousActivity()
{
    QString pId = previousRunningActivity();

    if(pId != "")
        m_activitiesController->setCurrentActivity(pId);
}


void Store::saveWorkareas()
{
    QListIterator<Workareas::Info *> i(m_workareasList);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        Workareas::Info *curWorks = i.next();
        if(curWorks){
            writeActivities.append(curWorks->id());
            writeSizes.append(QString::number(curWorks->workareas().size()));

            for(int j=0; j<curWorks->workareas().size(); j++)
                writeWorkareas.append(curWorks->name(j+1));
        }
    }

    WorkareasData::setActivities(writeActivities);
    WorkareasData::setNoOfWorkareas(writeSizes);
    WorkareasData::setWorkareasNames(writeWorkareas);
    WorkareasData::self()->writeConfig();
}


void Store::loadWorkareas()
{
    m_workareasList.clear();

    QStringList activitiesStorred = WorkareasData::activities();
    QStringList lengths = WorkareasData::noOfWorkareas();
    QStringList wnames = WorkareasData::workareasNames();

    QStringList activitiesRunning = m_activitiesController->listActivities();

    int max = 0;
    m_loading = true;

    foreach(const QString &id, activitiesStorred)
    {
        if (activitiesRunning.contains(id)){
            //find activity's position in stored file
            int pos = activitiesStorred.indexOf(id);

            //calculate the workareas position for this activity
            int fixedpos = 0;
            for(int j=0; j<pos; j++)
                fixedpos += lengths[j].toInt();

            //load workareas for this activity
            QStringList foundWorkAreas;
            for(int k=0; k<lengths[pos].toInt(); k++)
                foundWorkAreas.append(wnames[fixedpos+k]);

            //Add in model
            Workareas::Info *info = new Workareas::Info(id, this);

            for(int k=0; k<foundWorkAreas.size(); ++k)
                info->addWorkArea(foundWorkAreas[k]);

            m_workareasList.append(info);
            //m_workareasHash[id] = info;

            //INFO CONNECTIONS
            connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
            connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
            connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

            //SiGNALS
            emit activityAdded(id);

            //use it to find maxWorkareas
            if (foundWorkAreas.size() > max)
                max = foundWorkAreas.size();

            //remove that id from running activities
            activitiesRunning.removeAll(id);
        }
    }

    //all the activities that didnt exist in the storing file
    foreach(const QString &id, activitiesRunning){
        Workareas::Info *info = new Workareas::Info(id, this);

        int numberOfDesktops = TaskManager::TaskManager::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            info->addWorkArea(TaskManager::TaskManager::self()->desktopName(j+1));

        m_workareasList.append(info);

        //m_workareasHash[id] = info;

        connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        //SIGNALS
        emit activityAdded(id);

        //use it to find maxWorkareas
        if (numberOfDesktops > max)
            max = numberOfDesktops;
    }

    m_loading = false;
    m_maxWorkareas = max;
    emit maxWorkareasChanged(m_maxWorkareas);
}


void Store::setMaxWorkareas()
{
    if(!m_loading){
        int prevmax = m_maxWorkareas;
        int max = 0;

        QListIterator<Workareas::Info *> i(m_workareasList);

        while (i.hasNext()) {
            Workareas::Info *curWorks = i.next();
            if(curWorks){
                if(curWorks->workareas().count() > max)
                    max = curWorks->workareas().count();
            }
        }

        if (max != prevmax){
            m_maxWorkareas = max;
            emit maxWorkareasChanged(m_maxWorkareas);
        }
    }
}

QString Store::getNextDefWallpaper(){
    QString newwall="";
    if (m_nextDefaultWallpaper % 4 == 0)
        newwall = "../../Images/backgrounds/emptydesk1.png";
    else if (m_nextDefaultWallpaper % 4 == 1)
        newwall = "../../Images/backgrounds/emptydesk2.png";
    else if (m_nextDefaultWallpaper % 4 == 2)
        newwall = "../../Images/backgrounds/emptydesk3.png";
    else if (m_nextDefaultWallpaper % 4 == 3)
        newwall = "../../Images/backgrounds/emptydesk4.png";

    m_nextDefaultWallpaper++;

    return newwall;
}

QString Store::nextRunningActivity()
{
    int pos = findActivity(m_activitiesController->currentActivity());

    if(pos>-1){
        for(int i=pos+1; i<m_workareasList.size(); ++i){
            Workareas::Info *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
              return info->id();
        }

        for(int j=0; j<pos; ++j){
            Workareas::Info *info = m_workareasList[j];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
              return info->id();
        }
    }

    return "";
}

QString Store::previousRunningActivity()
{
    int pos = findActivity(m_activitiesController->currentActivity());

    if(pos>-1){
        for(int i=pos-1; i>=0; i--){
            Workareas::Info *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
              return info->id();
        }
        for(int j=m_workareasList.size()-1; j>pos; j--){
            Workareas::Info *info = m_workareasList[j];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
              return info->id();
        }
    }
    return "";
}


//PLUGINS

void Store::pluginUpdateWorkareasNameSlot(int w_pos)
{   
    QListIterator<Workareas::Info *> i(m_workareasList);

    while (i.hasNext()) {
        Workareas::Info *curWorks = i.next();
        if(curWorks && (curWorks->workareas().size() == w_pos) )
            renameWorkarea(curWorks->id(), w_pos, "");
    }

}

void Store::setUpdateBackgrounds(bool active)
{
    if(m_plgFindWallpaper)
        m_plgFindWallpaper->setPluginActive(active);
}

int Store::findActivity(QString activityId)
{
    for(int i=0; i<m_workareasList.size(); ++i){
        Workareas::Info *info = m_workareasList[i];
        if(info->id() == activityId)
            return i;
    }

    return -1;
}


}
#include "store.moc"
