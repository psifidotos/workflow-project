#include "activitymanager.h"

#include <QDir>
#include <QDebug>

#include <QModelIndex>

#include <KIconDialog>
#include <KIcon>
#include <KWindowSystem>
#include <KMessageBox>
#include <KDialog>
#include <KStandardDirs>

#include <KActivities/Controller>
#include <KActivities/Info>

#include <Plasma/Containment>
#include <Plasma/Corona>

////Plugins/////
#include "plugins/pluginchangeworkarea.h"

#include "../models/activitiesenhancedmodel.h"
#include "../models/activityitem.h"
#include "../models/listitem.h"

ActivityManager::ActivityManager(ActivitiesEnhancedModel *model,QObject *parent) :
    QObject(parent),
    m_activitiesCtrl(0),
    m_plChangeWorkarea(0),
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
    if (m_plChangeWorkarea)
        delete m_plChangeWorkarea;
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

void ActivityManager::changeWorkareaEnded(QString actId, int desktop)
{
    Q_UNUSED(actId);
    Q_UNUSED(desktop);

    if (m_plChangeWorkarea){
        delete m_plChangeWorkarea;
        m_plChangeWorkarea = 0;
    }
}

void ActivityManager::activityAddedSlot(QString id) {

    KActivities::Info *activity = new KActivities::Info(id, this);


    QString state = stateToString(activity->state());

    m_actModel->appendRow(new ActivityItem(id,activity->name(),
                                           activity->icon(),
                                           state,
                                           QStringList(),
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

////////////

void ActivityManager::setIcon(QString id, QString name)
{
    m_activitiesCtrl->setActivityIcon(id,name);
}

QString ActivityManager::chooseIcon(QString id)
{
    KIconDialog *dialog = new KIconDialog();
    dialog->setModal(false);
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

QString ActivityManager::chooseIconInKWin(QString id)
{
    KIconDialog *dialog = new KIconDialog();
    dialog->setModal(false);
    dialog->setWindowFlags(Qt::Popup | Qt::X11BypassWindowManagerHint);
   // dialog->setup(KIconLoader::Desktop);
   // dialog->setProperty("DoNotCloseController", true);
   // KWindowSystem::setOnDesktop(dialog->winId(), KWindowSystem::currentDesktop());
    dialog->showDialog();
    KDialog::centerOnScreen(dialog);
    dialog->activateWindow();
    //KWindowSystem::forceActiveWindow(dialog->winId());

    QString icon = dialog->openDialog();
    dialog->deleteLater();

    if (icon != "")
        setIcon(id,icon);

    return icon;
}


void ActivityManager::add(QString name) {
    m_activitiesCtrl->addActivity(name);
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

void ActivityManager::setCurrentInModel(QString activity, QString status)
{
    ActivityItem *activityObj= static_cast<ActivityItem *>(m_actModel->find(activity));
    if(activityObj)
        return activityObj->setCState(status);
}

void ActivityManager::moveActivityInModel(QString activity, int position)
{
    int posModel = m_actModel->getIndexFor(activity);
//    qDebug() << posModel << " ***** " <<position;
    if(posModel != position)
        m_actModel->moveRow(posModel, position);
}

///////////////Plugins

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
