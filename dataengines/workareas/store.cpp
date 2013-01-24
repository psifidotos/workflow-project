#include "store.h"

#include <QHash>

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

    QHashIterator<QString, Workareas::Info *> i(m_workareasHash);
    while (i.hasNext()) {
        i.next();
        Workareas::Info *curWorks = i.value();
        if(curWorks)
            delete curWorks;
    }

    m_workareasHash.clear();

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
    return ((Workareas::Info *)m_workareasHash[id]);
}

int Store::maxWorkareas() const
{
    return m_maxWorkareas;
}

QStringList Store::activities() const
{
    QStringList result;

    QHashIterator<QString, Workareas::Info *> i(m_workareasHash);

    while (i.hasNext()) {
        i.next();

        QString key = i.key();
        result.append(key);
        /*        Workareas::Info *curWorks = i.value();

        if(curWorks){
            writeActivities.append(i.key());
            writeSizes.append(QString::number(curWorks->workareas().size()));

            for(int j=0; j<curWorks->workareas().size(); j++)
                writeWorkareas.append(curWorks->name(j+1));
        }*/
    }

    return result;
}

void Store::addWorkarea(QString id, QString name)
{
    Workareas::Info *info = m_workareasHash[id];

    if (info){
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
    Workareas::Info *info = m_workareasHash[id];

    if (info){
        if(name == "")
            name = TaskManager::TaskManager::self()->desktopName(desktop);

        info->renameWorkarea(desktop, name);
    }

}

void Store::removeWorkarea(QString id, int desktop)
{
    Workareas::Info *info = m_workareasHash[id];

    if (info)
        info->removeWorkarea(desktop);
}


void Store::cloneActivity(QString from, QString to)
{
    Workareas::Info *infoFrom = m_workareasHash[from];
    Workareas::Info *infoTo = m_workareasHash[to];

    //The signal to clone comes earlier than the activityAdded one
    if(!infoTo){
        activityAddedSlot(to);
        infoTo = m_workareasHash[to];
    }

    if(infoFrom && infoTo){
        Workareas::Info *copy = infoFrom->copy(this);
        copy->m_id = infoTo->m_id;

        disconnect( m_workareasHash[to], SIGNAL(workareaAdded(QString,QString)) );
        disconnect( m_workareasHash[to], SIGNAL(workareaRemoved(QString,int)) );
        disconnect( m_workareasHash[to], SIGNAL(workareaInfoUpdated(QString)) );

        m_workareasHash.remove(to);

        connect(copy, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(copy, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(copy, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        m_workareasHash[to] = copy;

        workareaInfoUpdatedSlot(to);
    }

}

void Store::setBackground(QString id, QString background)
{
    Workareas::Info *info = m_workareasHash[id];

    if(info){
        if (background != "")
            info->setBackground(background);
        else
            info->setBackground(getNextDefWallpaper());
    }
}


void Store::activityAddedSlot(QString id)
{
    Workareas::Info *info = m_workareasHash[id];
    if(!info){
        info = new Workareas::Info(id, this);

        int numberOfDesktops = TaskManager::TaskManager::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            info->addWorkArea(TaskManager::TaskManager::self()->desktopName(j+1));

        m_workareasHash[id] = info;

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
    if ( m_workareasHash.contains(id) ){
        disconnect( m_workareasHash[id], SIGNAL(workareaAdded(QString,QString)) );
        disconnect( m_workareasHash[id], SIGNAL(workareaRemoved(QString,int)) );
        disconnect( m_workareasHash[id], SIGNAL(workareaInfoUpdated(QString)) );

        m_workareasHash.remove(id);

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

void Store::saveWorkareas()
{
    QHashIterator<QString, Workareas::Info *> i(m_workareasHash);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        i.next();

        Workareas::Info *curWorks = i.value();
        if(curWorks){
            writeActivities.append(i.key());
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
    m_workareasHash.clear();

    QStringList acts = WorkareasData::activities();
    QStringList lengths = WorkareasData::noOfWorkareas();
    QStringList wnames = WorkareasData::workareasNames();

    QStringList activities = m_activitiesController->listActivities();

    int max = 0;
    m_loading = true;

    foreach(const QString &id, activities)
    {
        if (acts.contains(id)){
            //find activity's position in stored file
            int pos = acts.indexOf(id);

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

            m_workareasHash[id] = info;

            //INFO CONNECTIONS
            connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
            connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
            connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

            //SiGNALS
            emit activityAdded(id);

            //use it to find maxWorkareas
            if (foundWorkAreas.size() > max)
                max = foundWorkAreas.size();
        }
        else{
            Workareas::Info *info = new Workareas::Info(id, this);

            int numberOfDesktops = TaskManager::TaskManager::self()->numberOfDesktops();

            for(int j=0; j<numberOfDesktops; j++)
                info->addWorkArea(TaskManager::TaskManager::self()->desktopName(j+1));

            m_workareasHash[id] = info;

            connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
            connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
            connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

            //SIGNALS
            emit activityAdded(id);

            //use it to find maxWorkareas
            if (numberOfDesktops > max)
                max = numberOfDesktops;
        }
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

        QHashIterator<QString, Workareas::Info *> i(m_workareasHash);

        while (i.hasNext()) {
            i.next();

            Workareas::Info *curWorks = i.value();
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


//PLUGINS

void Store::pluginUpdateWorkareasNameSlot(int w_pos)
{   
    QHashIterator<QString, Workareas::Info *> i(m_workareasHash);

    while (i.hasNext()) {
        i.next();

        Workareas::Info *curWorks = i.value();
        if(curWorks && (curWorks->workareas().size() == w_pos) )
            renameWorkarea(curWorks->id(), w_pos, "");
    }

}

void Store::setUpdateBackgrounds(bool active)
{
    if(m_plgFindWallpaper)
        m_plgFindWallpaper->setPluginActive(active);
}


}
#include "store.moc"
