#include "Store.h"

#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusReply>
#include <QDebug>
#include <QList>
#include <QVariant>

#include <KActivities/Controller>
#include <KActivities/Consumer>
#include <KActivities/Info>
#include <KWindowSystem>

#include "storeadaptor.h"
#include "workareasdata.h"
//#include <taskmanager/task.h>
#include "plugins/pluginupdateworkareasname.h"
#include "plugins/pluginsyncactivitiesworkareas.h"
#include "plugins/pluginfindwallpaper.h"

#include "info.h"


#include <KPluginFactory>
#include <KPluginLoader>

K_PLUGIN_FACTORY(StoreFactory,
                 registerPlugin<Store>();
)
K_EXPORT_PLUGIN(StoreFactory("workareamanagerd"))

static const char* DBUS_SERVICE = "org.kde.kded";
static const char* DBUS_OBJECT_PATH = "/modules/workareamanagerd";

Store::Store(QObject* parent, const QList<QVariant>&) :
    KDEDModule(parent),
    m_activitiesController(new KActivities::Controller(this)),
    m_loading(false),
    m_maxWorkareas(0),
    m_nextDefaultWallpaper(0),
    m_isRunning(false),
    m_plgUpdateWorkareasName(0),
    m_plgSyncActivitiesWorkareas(0),
    m_plgFindWallpaper(0)
{
 /*
    QDBusServiceWatcher *watcher = new QDBusServiceWatcher("org.kde.kactivitymanagerd",
                                                           QDBusConnection::sessionBus(),
                                                           QDBusServiceWatcher::WatchForRegistration);
    connect(watcher, SIGNAL(serviceRegistered(QString)), this, SLOT(managerServiceRegistered()));

    QDBusServiceWatcher *watcher2 = new QDBusServiceWatcher("org.kde.kwin",
                                                            QDBusConnection::sessionBus(),
                                                            QDBusServiceWatcher::WatchForRegistration);
    connect(watcher, SIGNAL(serviceRegistered(QString)), this, SLOT(managerServiceRegistered()));
*/
   // connect(m_activitiesController, SIGNAL(serviceStatusChanged(KActivities::Consumer::ServiceStatus)),
         //   this, SLOT(onServiceStatusChanged(KActivities::Consumer::ServiceStatus)));
  //  managerServiceRegistered();
    updateActivityList();
}

Store::~Store()
{
    saveWorkareas();

    QListIterator<Info *> i(m_workareasList);

    while (i.hasNext()) {
        Info *curWorks = i.next();
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

//Create a separate thread in order to trigger initialization based on the
//kwin approach in workspace.cpp
static QStringList
fetchActivityList(KActivities::Controller *controller) // could be member function, but actually it's much simpler this way
{
    return controller->listActivities();
}

void Store::updateActivityList()
{
    QFutureWatcher<QStringList>* watcher = new QFutureWatcher<QStringList>;
    connect( watcher, SIGNAL(finished()), SLOT(handleActivityReply()) );
    watcher->setFuture(QtConcurrent::run(fetchActivityList, m_activitiesController ));
}

void Store::handleActivityReply()
{
    QObject *watcherObject = 0;
    if (QFutureWatcher<QStringList>* watcher = dynamic_cast< QFutureWatcher<QStringList>* >(sender())) {
        QStringList res = watcher->result();
        qDebug() << res;
        //now the initialization can be started
        initSession();
    }

    if (watcherObject) {
        watcherObject->deleteLater(); // has done it's job
    }
}
/////////////////End of thread definition......

void Store::managerServiceRegistered()
{

 /*   QDBusServiceWatcher *watcher1 = new QDBusServiceWatcher("org.kde.kactivitymanagerd",
                                                     QDBusConnection::sessionBus(),
                                             QDBusServiceWatcher::WatchForRegistration);

    QDBusServiceWatcher *watcher2 = new QDBusServiceWatcher("org.kde.kwin",
                                                       QDBusConnection::sessionBus(),
                                                          QDBusServiceWatcher::WatchForRegistration);

    QDBusMessage message1;
    message1 = QDBusMessage::createMethodCall(QLatin1String("org.freedesktop.DBus"),
                                              QLatin1String("/"),
                                              QLatin1String("org.freedesktop.DBus"),
                                              QLatin1String("NameHasOwner"));
    message1 << QString("org.kde.kactivitymanagerd");
    QDBusReply<bool> reply1 = (watcher1->connection()).call(message1);
    bool connected1 = reply1.value();

    QDBusMessage message2;
    message2 = QDBusMessage::createMethodCall(QLatin1String("org.freedesktop.DBus"),
                                              QLatin1String("/"),
                                              QLatin1String("org.freedesktop.DBus"),
                                              QLatin1String("NameHasOwner"));
    message2 << QString("org.kde.kwin");
    QDBusReply<bool> reply2 = (watcher2->connection()).call(message2);
    bool connected2 = reply2.value();
*/
    if ( KActivities::Controller::serviceStatus() == KActivities::Controller::Running ){
        initSession();
    }
}

void Store::onServiceStatusChanged (KActivities::Consumer::ServiceStatus status)
{
    if ( status == KActivities::Controller::Running ){
        initSession();
    }
}

void Store::initSession()
{
    //QStringList activitiesRunning = m_activitiesController->listActivities();
    initSignals();

    loadWorkareas();

    connectToBus();

    m_isRunning = true;
    emit ServiceStatusChanged(m_isRunning);
    qDebug() << "Ok.....";
}


bool Store::connectToBus(const QString& service, const QString& path)
{
    m_service = service.isEmpty() ? DBUS_SERVICE : service;
    QString newPath = path.isEmpty() ? DBUS_OBJECT_PATH : path;

    if (!QDBusConnection::sessionBus().registerService(m_service)) {
        return false;
    }
    new StoreAdaptor(this);
    QDBusConnection::sessionBus().registerObject(newPath, this);

    return true;
}

void Store::initSignals()
{
 //   m_activitiesController = new KActivities::Controller(this);
    connect(m_activitiesController, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesController, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));

    m_plgSyncActivitiesWorkareas = new PluginSyncActivitiesWorkareas(this);
    connect(this, SIGNAL(MaxWorkareasChanged(int)),
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

bool Store::ServiceStatus()
{
    return m_isRunning;
}


Info *Store::get(QString id)
{
    int pos = findActivity(id);
    return ((Info *)m_workareasList[pos]);
}

int Store::MaxWorkareas() const
{
    return m_maxWorkareas;
}

QStringList Store::Activities() const
{
    QStringList result;

    QListIterator<Info *> i(m_workareasList);

    while (i.hasNext()) {
        Info *info = i.next();
        result.append(info->id());
    }

    return result;
}

QString Store::ActivityBackground(QString actId)
{
    Info *activity = get(actId);
    if (activity)
        return activity->background();
    else
        return "";
}

QStringList Store::Workareas(QString actId)
{
    Info *activity = get(actId);
    if (activity)
        return activity->workareas();
    else
        return QStringList();
}

void Store::createActivityChangedSignal(QString actId)
{
    Info *activity = get(actId);
    if (activity)
        emit ActivityInfoUpdated(actId, activity->background(), activity->workareas());
}

void Store::AddWorkarea(QString id, QString name)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Info *info = m_workareasList[pos];

        if(name==""){
            int counter = info->m_workareas.size();
            name = KWindowSystem::self()->desktopName(counter+1);
        }

        info->addWorkArea(name);

        // m_plgUpdateWorkareasName->checkFlag(info->m_workareas.size());
    }
}

void Store::RenameWorkarea(QString id, int desktop, QString name)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Info *info = m_workareasList[pos];
        if(name == ""){
            name = KWindowSystem::self()->desktopName(desktop);
        }

        info->renameWorkarea(desktop, name);
    }

}

void Store::RemoveWorkarea(QString id, int desktop)
{
    int pos = findActivity(id);

    if (pos>=0 && pos<m_workareasList.size()){
        Info *info = m_workareasList[pos];
        info->removeWorkarea(desktop);
    }
}


void Store::CloneActivity(QString from, QString to)
{
    int posFrom = findActivity(from);
    int posTo = findActivity(to);

    Info *infoFrom = 0;
    Info *infoTo = 0;

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
        Info *copy = infoFrom->copy(this);
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

void Store::MoveActivity(QString id, int toPosition)
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

void Store::setBackground(QString id, QString background)
{
    int pos = findActivity(id);

    if(pos>=0 && pos<m_workareasList.size() ){
        Info *info = m_workareasList[pos];
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
        Info *info = new Info(id, this);

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

void Store::activityRemovedSlot(QString id)
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

void Store::workareaAddedSlot(QString id, QString name)
{
    saveWorkareas();
    Info *activity = get(id);
    if (activity)
        emit WorkareaAdded(id, activity->workareas());

    setMaxWorkareas();
}

void Store::workareaRemovedSlot(QString id, int position)
{
    saveWorkareas();
    Info *activity = get(id);
    if (activity)
        emit WorkareaRemoved(id, activity->workareas());

    setMaxWorkareas();
}

void Store::workareaInfoUpdatedSlot(QString id)
{
    saveWorkareas();
    createActivityChangedSignal(id);
    //emit WorkareaInfoUpdated(id);
}

void Store::SetCurrentNextActivity()
{
    QString nId = nextRunningActivity();

    if(nId != "")
        m_activitiesController->setCurrentActivity(nId);
}

void Store::SetCurrentPreviousActivity()
{
    QString pId = previousRunningActivity();

    if(pId != "")
        m_activitiesController->setCurrentActivity(pId);
}


void Store::saveWorkareas()
{
    QListIterator<Info *> i(m_workareasList);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        Info *curWorks = i.next();
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
            Info *info = new Info(id, this);

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
        Info *info = new Info(id, this);

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
    emit MaxWorkareasChanged(m_maxWorkareas);
}


void Store::setMaxWorkareas()
{
    if(!m_loading){
        int prevmax = m_maxWorkareas;
        int max = 0;

        QListIterator<Info *> i(m_workareasList);

        while (i.hasNext()) {
            Info *curWorks = i.next();
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
            Info *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }

        for(int j=0; j<pos; ++j){
            Info *info = m_workareasList[j];
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
            Info *info = m_workareasList[i];
            KActivities::Info *activity = new KActivities::Info(info->id(), this);

            if ( (activity) && (activity->state() == KActivities::Info::Running) )
                return info->id();
        }
        for(int j=m_workareasList.size()-1; j>pos; j--){
            Info *info = m_workareasList[j];
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
    QListIterator<Info *> i(m_workareasList);

    while (i.hasNext()) {
        Info *curWorks = i.next();
        if(curWorks && (curWorks->workareas().size() == w_pos) )
            RenameWorkarea(curWorks->id(), w_pos, "");
    }

}

void Store::SetUpdateBackgrounds(bool active)
{
    if(m_plgFindWallpaper)
        m_plgFindWallpaper->setPluginActive(active);
}

int Store::findActivity(QString activityId)
{
    for(int i=0; i<m_workareasList.size(); ++i){
        Info *info = m_workareasList[i];
        if(info->id() == activityId)
            return i;
    }

    return -1;
}


//}
#include "Store.moc"
