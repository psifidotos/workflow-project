#include "activitymanager.h"

#include <QDir>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QIODevice>
#include <QAction>
#include <QGraphicsView>


#include <KIconDialog>
#include <KIcon>
#include <KWindowSystem>
#include <KConfigGroup>
#include <KConfig>
#include <KMessageBox>
#include <KStandardDirs>


#include <KActivities/Controller>
#include <KActivities/Info>

#include <Plasma/Containment>
#include <Plasma/Corona>

////Plugins/////
#include "plugins/pluginfindwallpaper.h"
#include "plugins/pluginshowwidgets.h"
#include "plugins/plugincloneactivity.h"
#include "plugins/pluginchangeworkarea.h"
#include "plugins/pluginaddactivity.h"

ActivityManager::ActivityManager(QObject *parent) :
    QObject(parent),
    m_activitiesCtrl(0),
    m_mainContainment(0),
    m_corona(0),
    m_plShowWidgets(0),
    m_plCloneActivity(0),
    m_plChangeWorkarea(0),
    m_plAddActivity(0),
    m_firstTime(true)
{
    m_activitiesCtrl = new KActivities::Controller(this);
}

ActivityManager::~ActivityManager()
{
    if (m_activitiesCtrl)
        delete m_activitiesCtrl;
    if (m_plShowWidgets)
        delete m_plShowWidgets;
    if (m_plCloneActivity)
        delete m_plCloneActivity;
    if (m_plChangeWorkarea)
        delete m_plChangeWorkarea;
    if (m_plAddActivity)
        delete m_plAddActivity;
}

void ActivityManager::setQMlObject(QObject *obj,Plasma::Containment *containment)
{
    qmlActEngine = obj;

    m_mainContainment = containment;

    if(m_mainContainment)
        if(m_mainContainment->corona())
            m_corona = m_mainContainment->corona();


    connect(this, SIGNAL(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));


    QStringList activities = m_activitiesCtrl->listActivities();

    foreach (const QString &id, activities) {
        activityAdded(id);
    }

    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAdded(QString)));
    connect(m_activitiesCtrl, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemoved(QString)));
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChanged(QString)));

}



QPixmap ActivityManager::disabledPixmapForIcon(const QString &ic)
{
    KIcon icon3(ic);
    return icon3.pixmap(KIconLoader::SizeHuge, QIcon::Disabled);
}


void ActivityManager::showWidgetsEndedSlot()
{
    if (m_plShowWidgets){
        delete m_plShowWidgets;
        m_plShowWidgets = 0;
    }
}


void ActivityManager::cloningStartedSlot()
{
    QMetaObject::invokeMethod(qmlActEngine, "cloningStartedSlot");
}

void ActivityManager::cloningEndedSlot()
{
    QMetaObject::invokeMethod(qmlActEngine, "cloningEndedSlot");
    if(m_plCloneActivity){
        delete m_plCloneActivity;
        m_plCloneActivity = 0;
    }
}


void ActivityManager::copyWorkareasSlot(QString from,QString to)
{
    QMetaObject::invokeMethod(qmlActEngine, "copyWorkareasSlot",
                              Q_ARG(QVariant, from),
                              Q_ARG(QVariant, to));
}


void ActivityManager::changeWorkareaEnded(QString actId, int desktop)
{
    Q_UNUSED(actId);
    Q_UNUSED(desktop);

    if (m_plChangeWorkarea){
        delete m_plChangeWorkarea;
        m_plChangeWorkarea = 0;
    }
}

void ActivityManager::addActivityEnded()
{
    if (m_plAddActivity){
        delete m_plAddActivity;
        m_plAddActivity = 0;
    }
}


void ActivityManager::activityAdded(QString id) {

    KActivities::Info *activity = new KActivities::Info(id, this);


    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    emit activityAddedIn(QVariant(id),
                         QVariant(activity->name()),
                         QVariant(activity->icon()),
                         QVariant(state),
                         QVariant(m_activitiesCtrl->currentActivity() == id));

    connect(activity, SIGNAL(infoChanged()), this, SLOT(activityDataChanged()));
    connect(activity, SIGNAL(stateChanged(KActivities::Info::State)), this, SLOT(activityStateChanged()));

    if((m_activitiesCtrl->currentActivity() == id) &&
            (m_firstTime)){
        m_firstTime = false;
        emit currentActivityInformationChanged(activity->name(),
                                               activity->icon());
    }

    updateWallpaper(id);

}

void ActivityManager::activityRemoved(QString id) {

    QMetaObject::invokeMethod(qmlActEngine, "activityRemovedIn",
                              Q_ARG(QVariant, id));

}

void ActivityManager::activityDataChanged()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    if (!activity) {
        return;
    }

    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }



    emit activityUpdatedIn(QVariant(activity->id()),
                           QVariant(activity->name()),
                           QVariant(activity->icon()),
                           QVariant(state),
                           QVariant(m_activitiesCtrl->currentActivity() == activity->id()));

    emit currentActivityInformationChanged(activity->name(),
                                           activity->icon());
}

void ActivityManager::activityStateChanged()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    const QString id = activity->id();
    if (!activity) {
        return;
    }
    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    //qDebug() <<activity->id()<< "-" << state;

    QMetaObject::invokeMethod(qmlActEngine, "setCState",
                              Q_ARG(QVariant, id),
                              Q_ARG(QVariant, state));

    updateWallpaper(id);

}

QString ActivityManager::getCurrentActivityName()
{
    KActivities::Info *activity = new KActivities::Info(m_activitiesCtrl->currentActivity(), this);
    return activity->name();
}

QString ActivityManager::getCurrentActivityIcon()
{
    KActivities::Info *activity = new KActivities::Info(m_activitiesCtrl->currentActivity(), this);
    return activity->icon();
}



/////////SLOTS
void ActivityManager::setCurrentNextActivity()
{
    QMetaObject::invokeMethod(qmlActEngine, "slotSetCurrentNextActivity");
}

void ActivityManager::setCurrentPreviousActivity()
{
    QMetaObject::invokeMethod(qmlActEngine, "slotSetCurrentPreviousActivity");
}

void ActivityManager::currentActivityChanged(const QString &id)
{
    QMetaObject::invokeMethod(qmlActEngine, "setCurrentSignal",
                              Q_ARG(QVariant, id));

    updateWallpaper(id);

    KActivities::Info *activity = new KActivities::Info(id, this);
    emit currentActivityInformationChanged(activity->name(),
                                           activity->icon());
}

////////////

void ActivityManager::setIcon(QString id, QString name)
{
    m_activitiesCtrl->setActivityIcon(id,name);
}

QString ActivityManager::chooseIcon(QString id)
{
    KIconDialog *dialog = new KIconDialog();
    dialog->setModal(true);
    dialog->setup(KIconLoader::Desktop);
    dialog->setProperty("DoNotCloseController", true);
    KWindowSystem::setOnDesktop(dialog->winId(), KWindowSystem::currentDesktop());
    dialog->showDialog();
    KWindowSystem::forceActiveWindow(dialog->winId());

    emit showedIconDialog();

    QString icon = dialog->openDialog();
    dialog->deleteLater();

    if (icon != "")
        setIcon(id,icon);

    emit answeredIconDialog();

    return icon;
}

void ActivityManager::add(QString name) {
    if(!m_plAddActivity){
        m_plAddActivity = new PluginAddActivity(this, m_activitiesCtrl);

        connect(m_plAddActivity, SIGNAL(addActivityEnded()), this, SLOT(addActivityEnded()) );

        m_plAddActivity->execute(name);
    }
}

void ActivityManager::setCurrent(QString id) {
    m_activitiesCtrl->setCurrentActivity(id);
}

void ActivityManager::stop(QString id) {
    m_activitiesCtrl->stopActivity(id);
}

void ActivityManager::start(QString id) {

    m_activitiesCtrl->startActivity(id);
}

void ActivityManager::setName(QString id, QString name) {
    m_activitiesCtrl->setActivityName(id,name);
}

void ActivityManager::remove(QString id) {
    m_activitiesCtrl->removeActivity(id);
}

/*
 int ActivityManager::askForDelete(QString activityName)
{
    QString question("Do you yeally want to delete activity ");
    question.append(activityName);
    question.append(" ?");
    int responce =  KMessageBox::questionYesNo(0,question,"Delete Activity");
    return responce;
}
*/

Plasma::Containment *ActivityManager::getContainment(QString actId)
{
        if(m_corona){
            for(int j=0; j<m_corona->containments().size(); j++){
                Plasma::Containment *tC = m_corona->containments().at(j);

                if (tC->containmentType() == Plasma::Containment::DesktopContainment){

                    if((tC->config().readEntry("activityId","") == actId)&&
                            (tC->config().readEntry("plugin","") != "desktopDashboard")){
                            return tC;
                    }

                }

            }
        }

    return 0;
}

void  ActivityManager::updateWallpaper(QString actId)
{
    QString background = getWallpaper(actId);
    if(background != "")
        QMetaObject::invokeMethod(qmlActEngine, "updateWallpaperSlot",
                                  Q_ARG(QVariant, actId),
                                  Q_ARG(QVariant, background));
}


QString ActivityManager::getWallpaper(QString source)
{
    PluginFindWallpaper plg(getContainment(source));
    return plg.getWallpaper(source);
}

void ActivityManager::showWidgetsExplorer(QString actId)
{
    if(!m_plShowWidgets){
        m_plShowWidgets = new PluginShowWidgets(this,m_mainContainment, m_activitiesCtrl);

        connect(m_plShowWidgets, SIGNAL(showWidgetsEnded()), this, SLOT(showWidgetsEndedSlot()));
        connect(m_plShowWidgets, SIGNAL(hidePopup()), this, SIGNAL(hidePopup()));

        m_plShowWidgets->execute(actId);
    }
}

void ActivityManager::cloneActivity(QString actId)
{
    if(!m_plCloneActivity){
        m_plCloneActivity = new PluginCloneActivity(this, m_activitiesCtrl);

        connect(m_plCloneActivity, SIGNAL(cloningStarted()),this,SLOT(cloningStartedSlot()));
        connect(m_plCloneActivity, SIGNAL(cloningEnded()),this,SLOT(cloningEndedSlot()));
        connect(m_plCloneActivity, SIGNAL(copyWorkareas(QString,QString)),this,SLOT(copyWorkareasSlot(QString,QString)));
        connect(m_plCloneActivity, SIGNAL(updateWallpaper(QString)),this,SLOT(updateWallpaper(QString)));

        m_plCloneActivity->execute(actId);
    }

}

void ActivityManager::setCurrentActivityAndDesktop(QString actId, int desktop)
{
    if(!m_plChangeWorkarea){
        m_plChangeWorkarea = new PluginChangeWorkarea(this, m_activitiesCtrl);

        connect(m_plChangeWorkarea, SIGNAL(changeWorkareaEnded(QString,int)), this, SLOT(changeWorkareaEnded(QString,int)));
        m_plChangeWorkarea->execute(actId, desktop);
    }
    else
        m_plChangeWorkarea->execute(actId, desktop);

}




#include "activitymanager.moc"
