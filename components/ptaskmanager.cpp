#include "ptaskmanager.h"


#include <QDebug>
#include <KWindowSystem>
#include <KTempDir>
#include <KStandardDirs>
#include <KIcon>
#include <KIconLoader>
#include <KActivities/Controller>

#include <QDBusInterface>
#include <QDBusConnection>

#include <QDesktopWidget>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

#include <taskmanager/task.h>

#include <Plasma/WindowEffects>

#include "models/taskitem.h"
#include "models/listmodel.h"


PTaskManager::PTaskManager(QObject *parent) :
    QObject(parent),
    m_controller(new KActivities::Controller(this)),
    m_taskModel(0),
    m_signalsWereInitialized(false)
{
    kwinSystem = KWindowSystem::KWindowSystem::self();

    m_taskModel = new ListModel(new TaskItem, this);

    init();
}


PTaskManager::~PTaskManager(){
    //something probably is not going too well with the
    //qt raster interface, it was crashing kwin
    //No need, the children will be deleted by the parent
    //was creating occussionaly crashes
    if(m_controller)
        delete m_controller;

    if(m_taskModel)
        delete m_taskModel;
}

void PTaskManager::init()
{
}

void PTaskManager::initSignals()
{
    foreach (WId source, kwinSystem->windows())
        windowAddedSlot(source);

    connect( kwinSystem, SIGNAL(windowAdded(WId)), this, SLOT(windowAddedSlot(WId)) );
    connect( kwinSystem, SIGNAL(windowRemoved(WId)), this, SLOT(windowRemovedSlot(WId)) );
    connect( kwinSystem, SIGNAL(windowChanged(WId, const unsigned long *)), this, SLOT(windowChangedSlot(WId,const ulong*)) );

    m_signalsWereInitialized = true;
}

///////////
void PTaskManager::hideDashboard()
{
    QDBusInterface remoteApp( "org.kde.plasma-desktop", "/App" );
    remoteApp.call( "showDashboard", false );
}

void PTaskManager::showDashboard()
{
    QDBusInterface remoteApp( "org.kde.plasma-desktop", "/App" );
    remoteApp.call( "showDashboard", true );
}
/////////////////////////////
//Slot for Signals from KWindowSystem
void PTaskManager::windowAddedSlot(WId id)
{
    QString wId;
    wId.setNum(id);
    windowAddedSlot(wId);
}

void PTaskManager::windowRemovedSlot(WId id)
{
    QString wId;
    wId.setNum(id);
    windowRemovedSlot(wId);
}

void PTaskManager::windowChangedSlot(WId id, const unsigned long *propertiesNew)
{
    QString wId;
    wId.setNum(id);
    if (propertiesNew[NETWinInfo::PROTOCOLS] & (NET::WMDesktop | NET::WMVisibleName) ||
            propertiesNew[NETWinInfo::PROTOCOLS2] & NET::WM2Activities) {
        updateValues(wId);
    }
}
//////////////////////////
//Slots to be used from KWin Scripting in order to handle the situation
//in which KWindowSystem signals should be used at all
bool PTaskManager::windowAddedSlot(QString id)
{
    WId wId = id.toULong();

    unsigned long properties =  NET::WMDesktop | NET::WMVisibleName |
            NET::WMWindowType | NET::WMState | NET::XAWMState ;

    unsigned long properties2 =  NET::WM2WindowClass ;

    KWindowInfo winInfo = kwinSystem->windowInfo (wId, properties, properties2);

    NET::WindowType type = winInfo.windowType(NET::NormalMask | NET::DialogMask | NET::OverrideMask |
                                              NET::UtilityMask | NET::DesktopMask | NET::DockMask |
                                              NET::TopMenuMask | NET::SplashMask | NET::ToolbarMask |
                                              NET::MenuMask);

    if (type != NET::Desktop && type != NET::Dock && type != NET::TopMenu &&
            type != NET::Splash && type != NET::Menu && type != NET::Toolbar &&
            !winInfo.hasState(NET::SkipPager)) {
        TaskItem *taskI = new TaskItem(m_taskModel);
        taskI->setCode(id);
        m_taskModel->appendRow(taskI);
        updateValues(id);
        return true;
    }
    return false;
}

void PTaskManager::windowRemovedSlot(QString id)
{
    emit taskRemoved(id);

    //removeTaskFromPreviewsLists(task->window());

    TaskItem *taskI = static_cast<TaskItem *>(m_taskModel->find(id));
    if(taskI){
        QModelIndex ind = m_taskModel->indexFromItem(taskI);
        m_taskModel->removeRow(ind.row());
    }
}

void PTaskManager::windowChangedSlot(QString id)
{
    updateValues(id);
}

//////////////////////////

void PTaskManager::updateValues(QString wId)
{
    WId id = wId.toULong();
    //QString wId;
    // wId.setNum(id);

    TaskItem *taskI = static_cast<TaskItem *>(m_taskModel->find(wId));
    if (taskI){
        //Activities
        unsigned long propertiesAct[] = { 0, NET::WM2Activities };
        NETWinInfo netInfo(QX11Info::display(), id, QX11Info::appRootWindow(), propertiesAct, 2);
        QString result(netInfo.activities());
        QStringList activities;
        bool onAllActivities = false;
        if (!result.isEmpty() && result != "ALL") {
            activities = result.split(',');

            onAllActivities = false;
        }
        else if(result == "ALL"){
            onAllActivities = true;
        }
        else if(result.isEmpty()){
            onAllActivities = false;
        }

        unsigned long properties =  NET::WMDesktop | NET::WMVisibleName ;
        unsigned long properties2 =  NET::WM2WindowClass ;
        KWindowInfo winInfo = kwinSystem->windowInfo (id, properties, properties2);

        QPixmap tempIcn = kwinSystem->icon(id, 256, 256, true);

        taskI->setValues(wId,
                         winInfo.onAllDesktops(),
                         onAllActivities,
                         QString(winInfo.windowClassClass()),
                         winInfo.visibleName(),
                         winInfo.desktop(),
                         activities);

        taskI->setIcon(QIcon(tempIcn));

    }
}

#ifdef Q_WS_X11
void PTaskManager::slotAddDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    info.setNumberOfDesktops(info.numberOfDesktops() + 1);
}

void PTaskManager::slotRemoveDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    int desktops = info.numberOfDesktops();
    if (desktops > 1) {
        info.setNumberOfDesktops(info.numberOfDesktops() - 1);
    }
}


void PTaskManager::setOnlyOnActivity(QString wd, QString activity)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wd));
    if(task){
        if((task->activities().count() == 0) ||
                (task->activities().at(0) != activity) ){
            Atom activities = XInternAtom(QX11Info::display(), (char *) "_KDE_NET_WM_ACTIVITIES", true);

            QByteArray joined = activity.toAscii();
            char *data = joined.data();

            XChangeProperty(QX11Info::display(), wd.toULong(), activities, XA_STRING, 8,
                            PropModeReplace, (unsigned char *)data, joined.size());
        }
    }
}

void PTaskManager::setOnAllActivities(QString wd)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wd));
    if(task && !task->onAllActivities()){

        Atom activities = XInternAtom(QX11Info::display(), (char *) "_KDE_NET_WM_ACTIVITIES", true);

        XChangeProperty(QX11Info::display(), wd.toULong(), activities, XA_STRING, 8,
                        PropModeReplace, (const unsigned char *)"ALL", 3);
    }
}

#endif

QPixmap PTaskManager::disabledPixmapForIcon(const QIcon &ic)
{
    KIcon icon3(ic);
    return icon3.pixmap(KIconLoader::SizeHuge, QIcon::Disabled);
}


///INVOKES

void PTaskManager::setOnDesktop(QString id, int desktop)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(id));
    if(task && task->desktop() != desktop)
        kwinSystem->setOnDesktop(id.toULong(),desktop);
}

void PTaskManager::setOnAllDesktops(QString id, bool b)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(id));
    if(task && task->onAllDesktops() != b)
        kwinSystem->setOnAllDesktops(id.toULong(), b);
}

void PTaskManager::removeTask(QString id)
{
    //This code must not be able to be executed from kwin scripts
    if(m_signalsWereInitialized){
        TaskManager::Task *t = TaskManager::TaskManager::self()->findTask(id.toULong());
        t->close();
    }
}

void PTaskManager::activateTask(QString id)
{
    kwinSystem->activateWindow(id.toULong());

    hideDashboard();
    emit hidePopup();
}

void PTaskManager::minimizeTask(QString id)
{
    //TaskManager::Task *t = taskMainM->findTask(id.toULong());
    //if(!t->isMinimized())
    //   t->setIconified(true);
    kwinSystem->minimizeWindow(id.toULong());
    // qDebug()<<t->name();
}

void PTaskManager::setCurrentDesktop(int desk)
{
    kwinSystem->setCurrentDesktop(desk);
}

/*
 *Three states are supported
 *
 *"oneDesktop" : single workarea
 *
 *"allDesktops" : all workareas in one Activity
 *
 *"allActivities" : all workareas in all Activities
 *
 */
void PTaskManager::setTaskState(QString wId, QString state, QString activity, int desktop)
{

    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(task){

        QString fActivity = "";

        if(activity == "")
            fActivity = m_controller->currentActivity();
        else
            fActivity = activity;

        //     console.debug("setTaskState:"+cod+"-"+val);

        if (state == "oneDesktop"){
            setOnAllDesktops(wId, false);
            setOnDesktop(wId, desktop);
            setOnlyOnActivity(wId, fActivity);
        }
        else if (state == "allDesktops"){
            setOnAllDesktops(wId ,true);
            setOnlyOnActivity(wId, fActivity);
        }
        else if (state == "sameDesktops"){
            setOnlyOnActivity(wId, activity);
            setOnDesktop(wId, desktop);
            setOnAllActivities(wId);
        }
        else if (state == "allActivities"){
            setOnAllDesktops(wId, true);
            setOnAllActivities(wId);
        }

    }
}


/*
 *This is used to update first the model and then send the signal to KDE
 *in  order to achieve the animation effect
 *
 */
void PTaskManager::setTaskActivityForAnimation(QString wId, QString activityId){
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(task){
        QStringList list;
        list.append(activityId);
        task->setActivities(list);
        // setOnlyOnActivity(wId, activityId);
    }
}


/*
 *This is used to update first the model and then send the signal to KDE
 *in  order to achieve the animation effect
 *
 */
void PTaskManager::setTaskDesktopForAnimation(QString wId, int desktop){
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(task){
        task->setDesktop(desktop);
        //  setOnDesktop(wId, desktop);
    }
}


/*
 *This is used mainly in the tasks animation
 */
QStringList PTaskManager::getTaskActivities(QString wId)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(task)
        return task->activities();

    return QStringList();
}


/*
 *This is used mainly in the tasks animation
 */
QIcon PTaskManager::getTaskIcon(QString wId)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(task)
        return task->icon();

    return QIcon();
}


/*
 *This is used to count the windows shown in a workareas
 */
int PTaskManager::tasksNumber(QString activity, int desktop, bool everywhereEnabled, QString excludeWindow, QString filter)
{
    int counter = 0;
    int numberOfDesktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();
    for(int i=0; i<m_taskModel->getCount(); ++i){
        TaskItem *task = static_cast<TaskItem *>(m_taskModel->at(i));
        if(task && (task->code() != excludeWindow) && task->name().toUpper().contains(filter.toUpper())){

            QString taskActivity = "";
            if (task->activities().size() > 0){
                taskActivity = task->activities()[0];
            }

            bool oneWorkarea = (!task->onAllActivities()&&
                                !task->onAllDesktops()&&
                                ((task->desktop() == desktop)||(numberOfDesktops == 1))&&
                                (taskActivity == activity));

            bool allWorkareas = ( !task->onAllActivities()&&
                                  (task->onAllDesktops()&&
                                   (taskActivity == activity)));

            bool sameWorkareas = (task->onAllActivities()&&
                                  !task->onAllDesktops()&&
                                  (task->desktop() == desktop));

            bool everywhere = (task->onAllActivities() &&
                               task->onAllDesktops() &&
                               everywhereEnabled);

            if(oneWorkarea || allWorkareas || sameWorkareas || everywhere)
                counter++;
        }
    }
    return counter;
}

/*
 *This is used to return a windows state
 *
 * "oneDesktop"
 * "allDesktops"
 * "sameDesktops"
 * "allActivities"
 *
 */
QString PTaskManager::windowState(QString window)
{
    TaskItem *task = static_cast<TaskItem *>(m_taskModel->find(window));
    if(task){
        if(!task->onAllActivities() && !task->onAllDesktops())
            return "oneDesktop";
        else if(task->onAllDesktops() && !task->onAllActivities())
            return "allDesktops";
        else if(task->onAllActivities() && !task->onAllDesktops())
            return "sameDesktops";
        else if(task->onAllActivities() && task->onAllDesktops())
            return "allActivities";
    }
    return "";
}


#include "ptaskmanager.moc"
