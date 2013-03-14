#include "WorkareaManager.h"

#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusReply>
#include <QDebug>
#include <QList>
#include <QVariant>

#include <KActivities/Controller>
#include <KActivities/Info>
#include <KWindowSystem>
#include <KAction>
#include <KActionCollection>

#include "workareamanageradaptor.h"
#include "workareasdata.h"

#include "mechanism/updateworkareasname.h"
#include "mechanism/syncactivitiesworkareas.h"
#include "mechanism/findwallpaper.h"
#include "mechanism/cloneactivityclass.h"

#include "workareainfo.h"


WorkareaManager::WorkareaManager(QObject* parent) :
    QObject(parent),
    m_activitiesController(new KActivities::Controller(this)),
    actionCollection(0),
    m_loading(false),
    m_maxWorkareas(0),
    m_nextDefaultWallpaper(0),
    m_isRunning(false),
    m_updateWorkareaName(""),
    m_mcmUpdateWorkareasName(0),
    m_mcmSyncActivitiesWorkareas(0),
    m_mcmFindWallpaper(0),
    m_mcmCloneActiviy(0)
{
    new WorkareaManagerAdaptor(this);
    QDBusConnection::sessionBus().registerObject(
                "/", this);

    initSession();
}

WorkareaManager::~WorkareaManager()
{
    saveWorkareas();

    QListIterator<WorkareaInfo *> i(m_workareasList);

    while (i.hasNext()) {
        WorkareaInfo *curWorks = i.next();
        if(curWorks)
            delete curWorks;
    }

    m_workareasList.clear();

    if(m_mcmUpdateWorkareasName)
        delete m_mcmUpdateWorkareasName;

    if(m_mcmSyncActivitiesWorkareas)
        delete m_mcmSyncActivitiesWorkareas;

    if(m_mcmFindWallpaper)
        delete m_mcmFindWallpaper;

    if(m_mcmCloneActiviy)
        delete m_mcmCloneActiviy;

    if(actionCollection)
        delete actionCollection;
}

//Create a separate thread in order to trigger initialization based on the
//kwin approach in workspace.cpp
static QStringList
fetchActivityList(KActivities::Controller *controller) // could be member function, but actually it's much simpler this way
{
    return controller->listActivities();
}

void WorkareaManager::updateActivityList()
{
    QFutureWatcher<QStringList>* watcher = new QFutureWatcher<QStringList>;
    connect( watcher, SIGNAL(finished()), SLOT(handleActivityReply()) );
    watcher->setFuture(QtConcurrent::run(fetchActivityList, m_activitiesController ));
}

void WorkareaManager::handleActivityReply()
{
    QObject *watcherObject = 0;
    if (QFutureWatcher<QStringList>* watcher = dynamic_cast< QFutureWatcher<QStringList>* >(sender())) {
        QStringList res = watcher->result();
        //now the initialization can be started
        initSession();
    }

    if (watcherObject) {
        watcherObject->deleteLater(); // has done it's job
    }
}
/////////////////End of thread definition......


void WorkareaManager::initSession()
{
    initSignals();

    loadWorkareas();

    //Global Shortcuts//
    actionCollection = new KActionCollection(this);
    actionCollection->setConfigGlobal(true);
    actionCollection->setConfigGroup("WorkFlow");

    KAction* a;
    a = static_cast< KAction* >(actionCollection->addAction("WorkFlow: Next Activity", this, SLOT(SetCurrentNextActivity())));
    a->setGlobalShortcut(KShortcut(Qt::META + Qt::Key_Tab));
    a = static_cast< KAction* >(actionCollection->addAction("WorkFlow: Previous Activity", this, SLOT(SetCurrentPreviousActivity())));
    a->setGlobalShortcut(KShortcut( (Qt::META + Qt::SHIFT) + Qt::Key_Tab));

    actionCollection->writeSettings();

    m_isRunning = true;
    emit ServiceStatusChanged(m_isRunning);
    //    qDebug() << "Ok.....";
}

void WorkareaManager::initSignals()
{
    connect(m_activitiesController, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesController, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));

    m_mcmSyncActivitiesWorkareas = new SyncActivitiesWorkareas(this);
    connect(this, SIGNAL(MaxWorkareasChanged(int)),
            m_mcmSyncActivitiesWorkareas, SLOT(maxWorkareasUpdated(int)) );

    m_mcmUpdateWorkareasName = new UpdateWorkareasName(this);
    connect(m_mcmUpdateWorkareasName, SIGNAL(updateWorkareasName(int)),
            this, SLOT(updateWorkareasNameSlot(int)) );

    m_mcmFindWallpaper = new FindWallpaper(m_activitiesController, this);
    connect(m_mcmFindWallpaper, SIGNAL(updateWallpaper(QString,QString)), this, SLOT(setBackground(QString,QString)));
}

void WorkareaManager::initBackgrounds()
{
    m_mcmFindWallpaper->initBackgrounds();
}

bool WorkareaManager::ServiceStatus()
{
    return m_isRunning;
}


WorkareaInfo *WorkareaManager::get(QString id)
{
    int pos = findActivity(id);
    return ((WorkareaInfo *)m_workareasList[pos]);
}

int WorkareaManager::MaxWorkareas() const
{
    return m_maxWorkareas;
}

QStringList WorkareaManager::Activities() const
{
    QStringList result;
    QListIterator<WorkareaInfo *> i(m_workareasList);

    while (i.hasNext()) {
        WorkareaInfo *info = i.next();
        result.append(info->id());
    }

    return result;
}

QString WorkareaManager::ActivityBackground(QString actId)
{
    WorkareaInfo *activity = get(actId);
    if (activity)
        return activity->background();
    else
        return "";
}

QStringList WorkareaManager::Workareas(QString actId)
{
    WorkareaInfo *activity = get(actId);
    if (activity)
        return activity->workareas();
    else
        return QStringList();
}

void WorkareaManager::createActivityChangedSignal(QString actId)
{
    WorkareaInfo *activity = get(actId);
    if (activity)
        emit ActivityInfoUpdated(actId, activity->background(), activity->workareas());
}

void WorkareaManager::AddWorkarea(QString id, QString name)
{
    WorkareaInfo *activity = get(id);
    if (activity){
        bool addTheWorkarea = false;

        if (m_mcmSyncActivitiesWorkareas &&   //This is used to determine if old workareas information exist
                (activity->workareas().size()<=m_mcmSyncActivitiesWorkareas->numberOfDesktops()) ) {
            addTheWorkarea = true;
        }

        if(addTheWorkarea){
            if(name==""){
                int counter = activity->m_workareas.size();
                name = KWindowSystem::self()->desktopName(counter+1);

                if(counter == m_mcmSyncActivitiesWorkareas->numberOfDesktops()){
                    m_updateWorkareaName = id;

                    //the maxWorkareas signal is not going to catch that one...
                    if(counter<m_maxWorkareas)
                        m_mcmSyncActivitiesWorkareas->addDesktop();
                }
            }

            activity->addWorkArea(name);
        }
        else{
            //Add a desktop just to show hidden workarea
            m_mcmSyncActivitiesWorkareas->addDesktop();
        }

        // m_mcmUpdateWorkareasName->checkFlag(info->m_workareas.size());
    }
}

void WorkareaManager::RenameWorkarea(QString id, int desktop, QString name)
{
    WorkareaInfo *activity = get(id);
    if (activity){
        if(name == ""){
            name = KWindowSystem::self()->desktopName(desktop);
        }

        activity->renameWorkarea(desktop, name);
    }
}

void WorkareaManager::RemoveWorkarea(QString id, int desktop)
{
    WorkareaInfo *activity = get(id);
    if (activity){
        int worksNumber = activity->m_workareas.size();
        int desksNumber = m_mcmSyncActivitiesWorkareas->numberOfDesktops();
        //remove hidden workareas when the user deletes any shown workarea
        if(worksNumber > desksNumber ){
            for(int i=desksNumber+1; i<=worksNumber; i++)
                activity->removeWorkarea(desksNumber+1);
        }

        activity->removeWorkarea(desktop);
    }
}


void WorkareaManager::cloneWorkareas(QString from, QString to)
{
    int posFrom = findActivity(from);
    int posTo = findActivity(to);

    WorkareaInfo *infoFrom = 0;
    WorkareaInfo *infoTo = 0;

    if (posFrom>=0 && posFrom<m_workareasList.size()){
        infoFrom = m_workareasList[posFrom];
    }

    //The signal to clone comes earlier than the activityAdded one
    if (posTo<0 || posTo>=m_workareasList.size()){
        activityAddedSlot(to);
        posTo = findActivity(to);
        infoTo = m_workareasList[posTo];
    }
    else{
        infoTo = m_workareasList[posTo];
    }

    if(infoFrom && infoTo){
        infoTo->cloneWorkareaInfo(infoFrom);

        workareaInfoUpdatedSlot(to);
    }
}

void WorkareaManager::MoveActivity(QString id, int toPosition)
{
    int fromPosition = findActivity(id);

    if (toPosition>=m_workareasList.size())
        toPosition = m_workareasList.size()-1;

    if (toPosition>=0 && toPosition<m_workareasList.size() &&
            fromPosition>=0 && fromPosition<m_workareasList.size() &&
            fromPosition != toPosition){
        m_workareasList.move(fromPosition, toPosition);
        saveWorkareas();

        emit ActivityOrdersChanged(Activities());
    }
}

void WorkareaManager::setBackground(QString id, QString background)
{
    int pos = findActivity(id);

    if(pos>=0 && pos<m_workareasList.size() ){
        WorkareaInfo *info = m_workareasList[pos];
        if (background != "")
            info->setBackground(background);
        else
            info->setBackground(getNextDefWallpaper());
    }
}


void WorkareaManager::activityAddedSlot(QString id)
{
    int pos = findActivity(id);

    if(pos<0 || pos>=m_workareasList.size() ){
        WorkareaInfo *info = new WorkareaInfo(id, this);

        int numberOfDesktops = KWindowSystem::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            info->addWorkArea(KWindowSystem::self()->desktopName(j+1));

        m_workareasList.append(info);
        //m_workareasHash[id] = info;

        connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        saveWorkareas();
        emit ActivityAdded(id);
        setMaxWorkareas();
    }
}

void WorkareaManager::activityRemovedSlot(QString id)
{
    int pos = findActivity(id);

    if(pos>=0 || pos<m_workareasList.size() ){
        disconnect( m_workareasList[pos], SIGNAL(workareaAdded(QString,QString)) );
        disconnect( m_workareasList[pos], SIGNAL(workareaRemoved(QString,int)) );
        disconnect( m_workareasList[pos], SIGNAL(workareaInfoUpdated(QString)) );

        m_workareasList.removeAt(pos);

        saveWorkareas();
        emit ActivityRemoved(id);
        setMaxWorkareas();
    }
}

void WorkareaManager::workareaAddedSlot(QString id, QString name)
{
    Q_UNUSED(name);
    saveWorkareas();
    WorkareaInfo *activity = get(id);
    if (activity)
        emit WorkareaAdded(id, activity->workareas());

    setMaxWorkareas();
}

void WorkareaManager::workareaRemovedSlot(QString id, int position)
{
    Q_UNUSED(position);
    saveWorkareas();
    WorkareaInfo *activity = get(id);
    if (activity)
        emit WorkareaRemoved(id, activity->workareas());

    setMaxWorkareas();
}

void WorkareaManager::workareaInfoUpdatedSlot(QString id)
{
    saveWorkareas();
    createActivityChangedSignal(id);
    //emit WorkareaInfoUpdated(id);
}

void WorkareaManager::cloningEndedSlot()
{
    if(m_mcmCloneActiviy){
        delete m_mcmCloneActiviy;
        m_mcmCloneActiviy = 0;
    }
}


void WorkareaManager::SetCurrentNextActivity()
{
    QString nId = nextRunningActivity();

    if(nId != "")
        m_activitiesController->setCurrentActivity(nId);
}

void WorkareaManager::SetCurrentPreviousActivity()
{
    QString pId = previousRunningActivity();

    if(pId != "")
        m_activitiesController->setCurrentActivity(pId);
}


void WorkareaManager::saveWorkareas()
{
    QListIterator<WorkareaInfo *> i(m_workareasList);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        WorkareaInfo *curWorks = i.next();
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


void WorkareaManager::loadWorkareas()
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
            WorkareaInfo *info = new WorkareaInfo(id, this);

            for(int k=0; k<foundWorkAreas.size(); ++k)
                info->addWorkArea(foundWorkAreas[k]);

            m_workareasList.append(info);
            //m_workareasHash[id] = info;

            //INFO CONNECTIONS
            connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
            connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
            connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

            //SiGNALS
            emit ActivityAdded(id);

            //use it to find maxWorkareas
            if (foundWorkAreas.size() > max)
                max = foundWorkAreas.size();

            //remove that id from running activities
            activitiesRunning.removeAll(id);
        }
    }

    //all the activities that didnt exist in the storing file
    foreach(const QString &id, activitiesRunning){
        WorkareaInfo *info = new WorkareaInfo(id, this);

        int numberOfDesktops = KWindowSystem::self()->numberOfDesktops();

        for(int j=0; j<numberOfDesktops; j++)
            info->addWorkArea(KWindowSystem::self()->desktopName(j+1));

        m_workareasList.append(info);

        //m_workareasHash[id] = info;

        connect(info, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)) );
        connect(info, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)) );
        connect(info, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

        //SIGNALS
        emit ActivityAdded(id);

        //use it to find maxWorkareas
        if (numberOfDesktops > max)
            max = numberOfDesktops;
    }

    initBackgrounds();
    m_loading = false;

    m_maxWorkareas = max;
    // emit MaxWorkareasChanged(m_maxWorkareas);
    setMaxWorkareas();
}


void WorkareaManager::setMaxWorkareas()
{
    if(!m_loading){
        int prevmax = m_maxWorkareas;
        int max = 0;

        QListIterator<WorkareaInfo *> i(m_workareasList);

        while (i.hasNext()) {
            WorkareaInfo *curWorks = i.next();
            if(curWorks){
                if(curWorks->workareas().count() > max)
                    max = curWorks->workareas().count();
            }
        }

        if (max != prevmax){
            m_maxWorkareas = max;
            emit MaxWorkareasChanged(m_maxWorkareas);
        }
    }
}

QString WorkareaManager::getNextDefWallpaper(){
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

QString WorkareaManager::nextRunningActivity()
{
    int pos = findActivity(m_activitiesController->currentActivity());

    if(pos>-1){
        for(int i=pos+1; i<m_workareasList.size(); ++i){
            WorkareaInfo *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }

        for(int j=0; j<pos; ++j){
            WorkareaInfo *info = m_workareasList[j];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }
    }

    return "";
}

QString WorkareaManager::previousRunningActivity()
{
    int pos = findActivity(m_activitiesController->currentActivity());

    if(pos>-1){
        for(int i=pos-1; i>=0; i--){
            WorkareaInfo *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }
        for(int j=m_workareasList.size()-1; j>pos; j--){
            WorkareaInfo *info = m_workareasList[j];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }
    }
    return "";
}


//PLUGINS
void WorkareaManager::CloneActivity(QString actId)
{
    if(!m_mcmCloneActiviy){
        m_mcmCloneActiviy = new CloneActivityClass(this, m_activitiesController);

        connect(m_mcmCloneActiviy, SIGNAL(copyWorkareas(QString,QString)),this,SLOT(cloneWorkareas(QString,QString)));
        connect(m_mcmCloneActiviy, SIGNAL(cloningEnded(bool)),this,SLOT(cloningEndedSlot()));

        m_mcmCloneActiviy->execute(actId);
    }
}

void WorkareaManager::updateWorkareasNameSlot(int w_pos)
{
    if(m_updateWorkareaName != ""){
        QListIterator<WorkareaInfo *> i(m_workareasList);

        while (i.hasNext()) {
            WorkareaInfo *curWorks = i.next();
            //rename only the workarea which was added
            if(curWorks && (curWorks->id() == m_updateWorkareaName) && (curWorks->workareas().size() == w_pos) )
                RenameWorkarea(curWorks->id(), w_pos, "");
        }

        m_updateWorkareaName = "";
    }
}

int WorkareaManager::findActivity(QString activityId)
{
    for(int i=0; i<m_workareasList.size(); ++i){
        WorkareaInfo *info = m_workareasList[i];
        if(info->id() == activityId)
            return i;
    }

    return -1;
}

#include "WorkareaManager.moc"
