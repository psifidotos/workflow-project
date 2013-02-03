#include "ptaskmanager.h"


#include <KDebug>
#include <KWindowSystem>
#include <KTempDir>
#include <KStandardDirs>
#include <KIcon>
#include <KIconLoader>
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
    m_taskModel(0)
{
    taskMainM = TaskManager::TaskManager::self();

    kwinSystem = KWindowSystem::KWindowSystem::self();

    m_taskModel = new ListModel(new TaskItem, this);

    init();
}


PTaskManager::~PTaskManager(){
    if(m_taskModel)
        delete m_taskModel;
}

void PTaskManager::init()
{
    foreach (TaskManager::Task *source, taskMainM->tasks())
        taskAdded(source);

    // task addition and removal
    connect(taskMainM , SIGNAL(taskAdded(::TaskManager::Task *)), this, SLOT(taskAdded(::TaskManager::Task *)));
    connect(taskMainM , SIGNAL(taskRemoved(::TaskManager::Task *)), this, SLOT(taskRemoved(::TaskManager::Task *)));

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


void PTaskManager::taskAdded(::TaskManager::Task *task)
{
    QString wId;
    wId.setNum(task->window());

    QPixmap tempIcn = task->icon(256,256,true);

    TaskItem *taskI = new TaskItem(wId,
                                   task->isOnAllDesktops(),
                                   task->isOnAllActivities(),
                                   task->classClass(),
                                   task->name(),
                                   QIcon(tempIcn),
                                   task->desktop(),
                                   task->activities(),
                                   m_taskModel
                                   );
    m_taskModel->appendRow(taskI);

    connect(task,SIGNAL(changed(::TaskManager::TaskChanges)),this,SLOT(taskUpdated(::TaskManager::TaskChanges)));

    // if(task->isOnAllActivities())
    //   if(!task->isOnAllDesktops())
    //      setOnAllDesktops(wId,true);
}

void PTaskManager::taskRemoved(::TaskManager::Task *task) {

    QString wId;
    wId.setNum(task->window());
    emit taskRemoved(wId);

    //removeTaskFromPreviewsLists(task->window());

    TaskItem *taskI = static_cast<TaskItem *>(m_taskModel->find(wId));
    if(taskI){
        QModelIndex ind = m_taskModel->indexFromItem(taskI);
        m_taskModel->removeRow(ind.row());
    }

    disconnect(task,SIGNAL(changed(::TaskManager::TaskChanges)),this,SLOT(taskUpdated(::TaskManager::TaskChanges)));
}

void PTaskManager::taskUpdated(::TaskManager::TaskChanges changes){
    ::TaskManager::Task *task = qobject_cast< ::TaskManager::Task * >(sender());

    if (!task) {
        return;
    }
    QString wId;
    wId.setNum(task->window());

    // only a subset of task information is exported
    QString typeOfMessage="";

    if((changes != TaskManager::TaskUnchanged) ||
            (changes != TaskManager::GeometryChanged) ||
            (changes != TaskManager::AttentionChanged)){

        TaskItem *taskI = static_cast<TaskItem *>(m_taskModel->find(wId));
        if(taskI){
            QPixmap tempIcn = task->icon(256,256,true);
            taskI->setCode(wId);
            taskI->setOnAllDesktops(task->isOnAllDesktops());
            taskI->setOnAllActivities(task->isOnAllActivities());
            taskI->setClassClass(task->classClass());
            taskI->setName(task->name());
            taskI->setIcon(QIcon(tempIcn));
            taskI->setDesktop(task->desktop());
            taskI->setActivities(task->activities());

            //if(task->isOnAllActivities())
            //  if(!task->isOnAllDesktops())
            //    setOnAllDesktops(wId,true);
        }

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
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    t->close();
}

void PTaskManager::activateTask(QString id)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    //   t->restore();
    t->activate();
    hideDashboard();
    emit hidePopup();
}

void PTaskManager::minimizeTask(QString id)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    if(!t->isMinimized())
        t->setIconified(true);
    qDebug()<<t->name();


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
            fActivity = taskMainM->currentActivity();
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
