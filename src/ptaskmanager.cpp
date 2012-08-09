#include "ptaskmanager.h"


#include <KDebug>
#include <KWindowSystem>
#include <KTempDir>
#include <KStandardDirs>
#include <KIcon>
#include <KIconLoader>
#include <QDBusInterface>
#include <QDBusConnection>

#include <QProcess>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

#include <taskmanager/task.h>

#include <Plasma/WindowEffects>


PTaskManager::PTaskManager(QObject *parent) :
    QObject(parent),
    m_mainWindowId(0)
{
    taskMainM = TaskManager::TaskManager::self();

    kwinSystem = KWindowSystem::KWindowSystem::self();

    m_tempdir = new KTempDir(KStandardDirs::locateLocal("tmp", "plasma-applet-workflow"));

    clearedPreviewsList = true;
}


PTaskManager::~PTaskManager(){
    //  foreach (const QString source, plasmaTaskEngine->sources())
    //     plasmaTaskEngine->disconnectSource(source, this);
    hideWindowsPreviews();
}

void PTaskManager::setQMlObject(QObject *obj)
{
    qmlTaskEngine = obj;

    connect(this, SIGNAL(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlTaskEngine,SLOT(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(taskRemovedIn(QVariant)),
            qmlTaskEngine,SLOT(taskRemovedIn(QVariant)));

    connect(this, SIGNAL(taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlTaskEngine,SLOT(taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(currentDesktopChanged(QVariant)),
            qmlTaskEngine, SLOT(currentDesktopChanged(QVariant)));

    connect(this, SIGNAL(numberOfDesktopsChanged(QVariant)),
            qmlTaskEngine, SLOT(setMaxDesktops(QVariant)));

    QMetaObject::invokeMethod(qmlTaskEngine, "currentDesktopChanged",
                              Q_ARG(QVariant, taskMainM->currentDesktop()));

    QMetaObject::invokeMethod(qmlTaskEngine, "setMaxDesktops",
                              Q_ARG(QVariant, kwinSystem->numberOfDesktops()));

    QMetaObject::invokeMethod(qmlTaskEngine, "setEffectsSystemStatus",
                              Q_ARG(QVariant, kwinSystem->compositingActive()));

    this->workAreaChanged();


    foreach (TaskManager::Task *source, taskMainM->tasks())
        taskAdded(source);

    // task addition and removal
    connect(taskMainM , SIGNAL(taskAdded(::TaskManager::Task *)), this, SLOT(taskAdded(::TaskManager::Task *)));
    connect(taskMainM , SIGNAL(taskRemoved(::TaskManager::Task *)), this, SLOT(taskRemoved(::TaskManager::Task *)));
    connect(taskMainM , SIGNAL(desktopChanged(int)), this, SLOT(desktopChanged(int)));

    connect(kwinSystem, SIGNAL(numberOfDesktopsChanged(int)), this, SLOT(changeNumberOfDesktops(int)));
    connect(kwinSystem, SIGNAL(workAreaChanged()),this,SLOT(workAreaChanged()));

   // QDBusInterface kwinApp( "org.kde.kwin", "/KWin" );
    //connect(kwinSystem,SIGNAL(compositingChanged(bool)),
    //        this, SLOT(compositingChanged(bool)));
  //  connect(kwinApp,SIGNAL(compositingToggled(bool)),
   //         this, SLOT(compositingChanged(bool)));

    QDBusConnection::sessionBus().connect("org.kde.kwin", "/KWin", "org.kde..KWin" ,"compositingToggled", this, SLOT(MySlot(uint)));

}
///////////
void PTaskManager::hideDashboard()
{
    QDBusInterface remoteApp( "org.kde.plasma-desktop", "/App" );
    remoteApp.call( "showDashboard", false );
}

void PTaskManager::changeNumberOfDesktops(int v)
{
    emit numberOfDesktopsChanged(QVariant(v));
}


void PTaskManager::desktopChanged (int desktop){
    emit currentDesktopChanged(QVariant(desktop));
}

WId PTaskManager::getMainWindowId(){
    return m_mainWindowId;
}

void PTaskManager::taskAdded(::TaskManager::Task *task)
{
    QString wId;
    wId.setNum(task->window());

    //  qDebug()<<"WinAdded:"<<wId;
    QPixmap tempIcn = task->icon(256,256,true);

    emit taskAddedIn(QVariant(wId),
                     QVariant(task->isOnAllDesktops()),
                     QVariant(task->isOnAllActivities()),
                     QVariant(task->classClass()),
                     QVariant(task->name()),
                     QVariant(QIcon(tempIcn)),
                     QVariant(false),
                     QVariant(task->desktop()),
                     QVariant(task->activities()));

    connect(task,SIGNAL(changed(::TaskManager::TaskChanges)),this,SLOT(taskUpdated(::TaskManager::TaskChanges)));
}

void PTaskManager::taskRemoved(::TaskManager::Task *task) {

    QString wId;
    wId.setNum(task->window());

    // QMetaObject::invokeMethod(qmlTaskEngine, "taskRemovedIn",
    //                         Q_ARG(QVariant, wId));

    emit taskRemovedIn(QVariant(wId));

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
    QString typeOfMessage;
    switch (changes) {
    case TaskManager::EverythingChanged:
        typeOfMessage = "everything";
        break;
    case TaskManager::IconChanged:
        typeOfMessage = "icon";
        break;
    case TaskManager::NameChanged:
        typeOfMessage = "name";
        break;
    case TaskManager::DesktopChanged:
        typeOfMessage = "desktop";
        break;
    case TaskManager::ActivitiesChanged:
        typeOfMessage = "activities";
        break;
    default:
        break;
    }
    QPixmap tempIcn = task->icon(256,256,true);
    emit taskUpdatedIn(QVariant(wId),
                       QVariant(task->isOnAllDesktops()),
                       QVariant(task->isOnAllActivities()),
                       QVariant(task->classClass()),
                       QVariant(task->name()),
                       QVariant(QIcon(tempIcn)),
                       QVariant(task->desktop()),
                       QVariant(task->activities()),
                       QVariant(typeOfMessage));

}

void PTaskManager::compositingChanged(bool b){
    QMetaObject::invokeMethod(qmlTaskEngine, "setEffectsSystemStatus",
                              Q_ARG(QVariant, b));

    qDebug()<<"Composition Effects:"<<b;

}

void PTaskManager::workAreaChanged(){
    QRect screenRect = kwinSystem->workArea();
    float ratio = (float)screenRect.height()/(float)screenRect.width();
    QMetaObject::invokeMethod(qmlTaskEngine, "setScreenRatio",
                              Q_ARG(QVariant, ratio));

 //   qDebug()<<ratio;

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
    Atom activities = XInternAtom(QX11Info::display(), (char *) "_KDE_NET_WM_ACTIVITIES", true);

    QByteArray joined = activity.toAscii();
    char *data = joined.data();

    XChangeProperty(QX11Info::display(), wd.toULong(), activities, XA_STRING, 8,
                    PropModeReplace, (unsigned char *)data, joined.size());
}

void PTaskManager::setOnAllActivities(QString wd)
{
    Atom activities = XInternAtom(QX11Info::display(), (char *) "_KDE_NET_WM_ACTIVITIES", true);

    XChangeProperty(QX11Info::display(), wd.toULong(), activities, XA_STRING, 8,
                    PropModeReplace, (const unsigned char *)"ALL", 3);
}


#endif

QPixmap PTaskManager::disabledPixmapForIcon(const QIcon &ic)
{
    KIcon icon3(ic);
    return icon3.pixmap(KIconLoader::SizeHuge, QIcon::Disabled);
}

void PTaskManager::setTopXY(int x1,int y1)
{
    topX = x1;
    topY = y1;
}


void PTaskManager::showWindowsPreviews()
{

    //    m_mainWindowId = RootWindow (QX11Info::display(), DefaultScreen (QX11Info::display()));
    //    qDebug() << m_mainWindowId;
    if (previewsIds.size()>0) {
        Plasma::WindowEffects::showWindowThumbnails(m_mainWindowId,previewsIds,previewsRects);
        clearedPreviewsList = false;
    }

    if ((previewsIds.size() == 0)&&(clearedPreviewsList == false)) {
        Plasma::WindowEffects::showWindowThumbnails(m_mainWindowId,previewsIds,previewsRects);
        clearedPreviewsList = true;
    }

}

void PTaskManager::hideWindowsPreviews()
{
    previewsIds.clear();
    previewsRects.clear();
    showWindowsPreviews();
}

void PTaskManager::setMainWindowId(WId win)
{
    if(m_mainWindowId != win){
        m_mainWindowId = win;
        showWindowsPreviews();


    }
}


float PTaskManager::getWindowRatio(QString win)
{
    WId winId = win.toULong();

    QList<WId> wList;
    wList.append(winId);

    QList<QSize> sList;
    sList = Plasma::WindowEffects::windowSizes(wList);

    if (sList.size()>0){
        QSize wSz = sList.at(0);

        return (float)(wSz.rheight())/(float)(wSz.rwidth());
    }

    return 0;
}

int PTaskManager::indexOfPreview(WId window)
{

    for (int i=0; i<previewsIds.size(); i++)
        if ( previewsIds.at(i) == window )
            return i;

    return -1;
}

void PTaskManager::setWindowPreview(QString win,int x, int y, int width, int height)
{
    //int xEr = topX + 12;
    //int yEr = topY + 75;
  //  int xEr = topX+13;
  //  int yEr = topY+42;

    //QRect prSize(x+xEr,y+yEr,width,height);
    //   QRect prSize(x,y,width,height);
    QRect prSize(topX+x,topY+y,width,height);
    WId winId = win.toULong();

    int pos = indexOfPreview(winId);

    if (pos>-1){
        previewsRects[pos] = prSize;

        if(pos>0){
            previewsRects.move(pos,0);
            previewsIds.move(pos,0);
        }
    }
    else{
        previewsRects.insert(0, prSize);
        previewsIds.insert(0, winId);
        //   previewsRects << prSize;
        //  previewsIds << winId;
    }

    showWindowsPreviews();
}

void PTaskManager::removeWindowPreview(QString win)
{
    WId winId = win.toULong();

    int pos = indexOfPreview(winId);

    if (pos>-1){
        previewsRects.removeAt(pos);
        previewsIds.removeAt(pos);
    }

    showWindowsPreviews();
}

int PTaskManager::getMaxDesktops()
{
    return taskMainM->numberOfDesktops();
}

///INVOKES
QString PTaskManager::getDesktopName(int n)
{
    return taskMainM->desktopName(n);
}

void PTaskManager::setOnDesktop(QString id, int desk)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    t->toDesktop(desk);
    kwinSystem->setOnDesktop(id.toULong(),desk);
}

void PTaskManager::setOnAllDesktops(QString id, bool b)
{
    kwinSystem->setOnAllDesktops(id.toULong(), b);
}

void PTaskManager::closeTask(QString id)
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
}

void PTaskManager::setCurrentDesktop(int desk)
{
    kwinSystem->setCurrentDesktop(desk);
}


/*

QPixmap PTaskManager::windowPreview(QString win, int size)
{
    WId window = win.toULong();

    QPixmap thumbnail = QPixmap::grabWindow(window);

    //  ::TaskManager::Task *tsk = taskMainM->findTask(window);
    //  return tsk->pixmap();

    qDebug()<<"-32-"<<m_tempdir->name();
    return thumbnail;
}

QPixmap PTaskManager::windowScreenshot(QString win, int chng)
{
    QString program = "import";
    QStringList arguments;
    arguments << "-window" << win;
    arguments << "-silent";

    QString filePath(m_tempdir->name()+win+".png");
    arguments << filePath;

    QProcess *myProcess = new QProcess(this);
    myProcess->start(program, arguments);

    QPixmap retPix = QPixmap(filePath);

    return retPix;
}

float PTaskManager::windowScreenshotRatio(QString win)
{


    QString filePath(m_tempdir->name()+win+".png");

    QPixmap retPix = QPixmap(filePath);

    float res = (float)retPix.width() / retPix.height();

    if (!retPix.isNull())
        return res;
    else
        return 0;

}


*/


#include "ptaskmanager.moc"
