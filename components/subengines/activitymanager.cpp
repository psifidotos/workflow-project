#include "activitymanager.h"

#include <QDir>
#include <QDebug>

#include <QModelIndex>

#include <KIconDialog>
#include <KIcon>
#include <KWindowSystem>
#include <KMessageBox>
#include <KStandardDirs>

#include <KActivities/Controller>
#include <KActivities/Info>

#include <Plasma/Containment>
#include <Plasma/Corona>

////Plugins/////
#include "plugins/plugincloneactivity.h"
#include "plugins/pluginchangeworkarea.h"
#include "plugins/pluginaddactivity.h"

#include "../models/activitiesenhancedmodel.h"
#include "../models/activityitem.h"
#include "../models/listitem.h"

ActivityManager::ActivityManager(ActivitiesEnhancedModel *model,QObject *parent) :
    QObject(parent),
    m_activitiesCtrl(0),
    m_plCloneActivity(0),
    m_plChangeWorkarea(0),
    m_plAddActivity(0),
    m_firstTime(true),
    m_actModel(model)
{
    m_activitiesCtrl = new KActivities::Controller(this);

    init();
}

ActivityManager::~ActivityManager()
{
    if (m_activitiesCtrl)
        delete m_activitiesCtrl;
    if (m_plCloneActivity)
        delete m_plCloneActivity;
    if (m_plChangeWorkarea)
        delete m_plChangeWorkarea;
    if (m_plAddActivity)
        delete m_plAddActivity;
}

void ActivityManager::init()
{
    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesCtrl, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));

    QStringList activities = m_activitiesCtrl->listActivities();

    foreach (const QString &id, activities)
        activityAddedSlot(id);
}

QPixmap ActivityManager::disabledPixmapForIcon(const QString &ic)
{
    KIcon icon3(ic);
    return icon3.pixmap(KIconLoader::SizeHuge, QIcon::Disabled);
}

void ActivityManager::cloningEndedSlot(bool updateWallpapers)
{
    emit cloningEnded(updateWallpapers);

    if(m_plCloneActivity){
        delete m_plCloneActivity;
        m_plCloneActivity = 0;
    }
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


void ActivityManager::activityAddedSlot(QString id) {

    KActivities::Info *activity = new KActivities::Info(id, this);


    QString state = stateToString(activity->state());

    m_actModel->appendRow(new ActivityItem(id,activity->name(),
                                           activity->icon(),
                                           state,
                                           "",
                                           m_actModel));


    connect(activity, SIGNAL(infoChanged()), this, SLOT(activityUpdatedSlot()));
    connect(activity, SIGNAL(stateChanged(KActivities::Info::State)),
            this, SLOT(activityStateChangedSlot()) );

    emit activityAdded(id);

}

void ActivityManager::activityRemovedSlot(QString id) {

    ActivityItem *activity = static_cast<ActivityItem *>(m_actModel->find(id));
    if(activity){
        QModelIndex ind = m_actModel->indexFromItem(activity);
        m_actModel->removeRow(ind.row(), QModelIndex());

        emit activityRemoved(id);
    }
}

void ActivityManager::activityUpdatedSlot()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    if (!activity) {
        return;
    }

    QString state = stateToString(activity->state());

    ActivityItem *activityObj = static_cast<ActivityItem *>(m_actModel->find(activity->id()));
    if(activityObj){
        activityObj->setName(activity->name());
        activityObj->setIcon(activity->icon());
        activityObj->setCState(state);
    }

}

void ActivityManager::activityStateChangedSlot()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    const QString id = activity->id();
    if (!activity) {
        return;
    }
    QString state = stateToString(activity->state());

    ActivityItem *activityObj= static_cast<ActivityItem *>(m_actModel->find(id));
    if(activityObj)
        activityObj->setCState(state);

}

QString ActivityManager::name(QString id)
{
    ActivityItem *activityObj= static_cast<ActivityItem *>(m_actModel->find(id));
    if(activityObj)
        return activityObj->name();
    return "";
}

QString ActivityManager::cstate(QString id)
{
    ActivityItem *activityObj= static_cast<ActivityItem *>(m_actModel->find(id));
    if(activityObj)
        return activityObj->cstate();
    return "";
}

/////////SLOTS

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


void ActivityManager::setCurrentNextActivity()
{
    QString nId = nextRunningActivity();

    if(nId != "")
        setCurrent(nId);
}

void ActivityManager::setCurrentPreviousActivity()
{
    QString pId = previousRunningActivity();

    if(pId != "")
        setCurrent(pId);

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

    QString icon = dialog->openDialog();
    dialog->deleteLater();

    if (icon != "")
        setIcon(id,icon);

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



QString ActivityManager::stateToString(int stateNum)
{
    QString state="";

    switch (stateNum) {
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

    return state;
}


QString ActivityManager::nextRunningActivity()
{
    ListItem *activity = m_actModel->find(m_activitiesCtrl->currentActivity());
    int pos =  (m_actModel->indexFromItem(activity)).row();

    if(pos>-1){
        for(int i=pos+1; i<m_actModel->getCount(); ++i){
            ActivityItem *activityTemp = static_cast<ActivityItem *>(m_actModel->at(i));
            if ( (activityTemp) && (activityTemp->cstate() == "Running"))
              return activityTemp->code();
        }
        for(int j=0; j<pos; ++j){
            ActivityItem *activityTemp2 = static_cast<ActivityItem *>(m_actModel->at(j));
            if ( (activityTemp2) && (activityTemp2->cstate() == "Running"))
              return activityTemp2->code();
        }
    }

    return "";
}

QString ActivityManager::previousRunningActivity()
{
    ListItem *activity = m_actModel->find(m_activitiesCtrl->currentActivity());
    int pos =  (m_actModel->indexFromItem(activity)).row();

    if(pos>-1){
        for(int i=pos-1; i>=0; i--){
            ActivityItem *activityTemp = static_cast<ActivityItem *>(m_actModel->at(i));
            if ( (activityTemp) && (activityTemp->cstate() == "Running"))
              return activityTemp->code();
        }
        for(int j=m_actModel->getCount()-1; j>pos; j--){
            ActivityItem *activityTemp2 = static_cast<ActivityItem *>(m_actModel->at(j));
            if ( (activityTemp2) && (activityTemp2->cstate() == "Running"))
              return activityTemp2->code();
        }
    }
    return "";
}

///////////////Plugins


void ActivityManager::cloneActivity(QString actId)
{
    if(!m_plCloneActivity){
        m_plCloneActivity = new PluginCloneActivity(this, m_activitiesCtrl);

        connect(m_plCloneActivity, SIGNAL(cloningStarted(bool)),this,SIGNAL(cloningStarted(bool)));
        connect(m_plCloneActivity, SIGNAL(cloningEnded(bool)),this,SLOT(cloningEndedSlot(bool)));
        connect(m_plCloneActivity, SIGNAL(copyWorkareas(QString,QString)),this,SIGNAL(cloningCopyWorkareas(QString,QString)));
        //connect(m_plCloneActivity, SIGNAL(updateWallpaper(QString)),this,SIGNAL(updateWallpaper(QString)));

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
