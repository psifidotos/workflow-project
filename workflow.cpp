/***************************************************************************
 *   Copyright (C) 2011 by Martin Gräßlin <mgraesslin@kde.org>             *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#include "workflow.h"

#include <KDebug>
#include <KGlobalSettings>
#include <KConfigGroup>
#include <KSharedConfig>
#include <KWindowSystem>

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>
#include <QGraphicsView>
#include <QRectF>
#include <QString>



#include <Plasma/Extender>
#include <Plasma/ExtenderItem>
#include <Plasma/ToolTipManager>
#include <Plasma/Containment>

#include "workflowsettings.h"


WorkFlow::WorkFlow(QObject *parent, const QVariantList &args):
    Plasma::PopupApplet(parent, args),
    m_mainWidget(0),
    actManager(0),
    taskManager(0)
{
    setPopupIcon("preferences-activities");
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setPassivePopup(true);
    // setHasConfigurationInterface(true);

    actManager = new ActivityManager(this);
    taskManager = new PTaskManager(this);

    m_zoomFactor = 50;
    m_showWindows = true;
    m_animations = true;
    m_lockActivities = false;
}

WorkFlow::~WorkFlow()
{
    saveConfigurationFiles();
    saveWorkareas();

    //clear workareas QHash
    QHashIterator<QString, QStringList *> i(storedWorkareas);
    while (i.hasNext()) {
        i.next();
        QStringList *curWorks = i.value();
        curWorks->clear();
        delete curWorks;
    }
    storedWorkareas.clear();
    //

    delete actManager;
    delete taskManager;
}

void WorkFlow::init(){

    Plasma::ToolTipManager::self()->registerWidget(this);

    extender()->setEmptyExtenderMessage(i18n("No Activities..."));

    extender()->setMinimumWidth(500);
    extender()->setMinimumHeight(300);

    //   extender()->setMaximumWidth(1500);
    //  extender()->setMaximumHeight(1200);

    if (extender()->item("WorkFlow") == 0) {

        item = new Plasma::ExtenderItem(extender());

        initExtenderItem(item);

        item->setName("WorkFlow");
        item->setTitle("WorkFlow");

        //     QString dW = appConfig.readEntry("DialogWidth","750");
        //   QString dH = appConfig.readEntry("DialogHeight","400");
        //
        //   qDebug() << dW<<"-"<<dH;



    }

    // extender()->setPreferredWidth(1000);
    //  extender()->setPreferredHeight(700);

}

void WorkFlow::initExtenderItem(Plasma::ExtenderItem *item) {

    m_mainWidget = new QGraphicsWidget(this);

    appConfig = config();

    //   QString wD = appConfig.readEntry("PopupWidth", "800");
    //   QString hD = appConfig.readEntry("PopupHeight", "600");

    //  m_mainWidget->setPreferredSize(wD.toFloat(), hD.toFloat());
    //  m_mainWidget->setPreferredWidth(750);
    //  m_mainWidget->setPreferredHeight(400);
    //  m_mainWidget->setMinimumSize(750, 400);

    mainLayout = new QGraphicsLinearLayout(m_mainWidget);
    mainLayout->setOrientation(Qt::Vertical);
    mainLayout->setContentsMargins(0, 0, 0, 0);
    mainLayout->setSpacing(0);

    KStandardDirs *sd =    KGlobal::dirs();

    QString path =  sd->findResource("data","plasma-workflowplasmoid/qml/Activities2.qml");

    declarativeWidget = new Plasma::DeclarativeWidget();
    //  declarativeWidget->setInitializationDelayed(true);
    declarativeWidget->setQmlPath(path);

    mainLayout->addItem(declarativeWidget);
    m_mainWidget->setLayout(mainLayout);

    if (declarativeWidget->engine()) {
        QDeclarativeContext *ctxt = declarativeWidget->engine()->rootContext();
        if (ctxt) {
            ctxt->setContextProperty("activityManager", actManager);
            ctxt->setContextProperty("taskManager", taskManager);
            ctxt->setContextProperty("workflowManager", this);

            QObject *rootObject = dynamic_cast<QObject *>(declarativeWidget->rootObject());
            QObject *qmlActEng = rootObject->findChild<QObject*>("instActivitiesEngine");
            QObject *qmlTaskEng = rootObject->findChild<QObject*>("instTasksEngine");
            mainQML = rootObject;

            loadWorkareas();

            if(!rootObject)
                qDebug() << "root was not found...";
            else{
                if(qmlActEng)
                    actManager->setQMlObject(qmlActEng);
                if(qmlTaskEng){
                    taskManager->setQMlObject(qmlTaskEng);
                    //  qDebug()<<view()->window()->winId();

                }
            }
            //qDebug()<<this->view()->winId();
            loadConfigurationFiles();
        }
    }

    //the activitymanager class will be directly accessible from qml

    item->setWidget(m_mainWidget);

    connect(this,SIGNAL(geometryChanged()),this,SLOT(geomChanged()));
    connect(this,SIGNAL(newStatus(Plasma::ItemStatus)),this,SLOT(statusChanged(Plasma::ItemStatus)));
    connect(this,SIGNAL(releaseVisualFocus()),this,SLOT(releasedVisualFocus()));
    connect(this,SIGNAL(activate()),this,SLOT(activated()));

    connect(KWindowSystem::self(),SIGNAL(activeWindowChanged(WId)),this,SLOT(activeWindowChanged(WId)));

    //m_mainWidget->resize(wD.toFloat(),hD.toFloat());
}
///SLOTS

void WorkFlow::hidePopupDialog()
{
    this->hidePopup();
}

void WorkFlow::setMainWindowId()
{

    //taskManager->setMainWindowId(view()->window()->winId());

    QRectF rf = this->geometry();
    taskManager->setTopXY(rf.x(),rf.y());

    //taskManager->setMainWindowId(view()->winId());
    taskManager->setMainWindowId(view()->effectiveWinId());
}

void WorkFlow::geomChanged()
{
    QRectF rf = this->geometry();
    taskManager->setTopXY(rf.x(),rf.y());
}

void WorkFlow::statusChanged(Plasma::ItemStatus status)
{
    qDebug() << "Plasmoid status:" << status;
}

void WorkFlow::showedEvent(QShowEvent *evt)
{
    qDebug() << "Plasmoid status:" << evt->type();
}

void WorkFlow::releasedVisualFocus()
{
    qDebug() << "Released Visual Focus...";
}

void WorkFlow::activated()
{
    qDebug() << "Plasmoid activated...";
}


void WorkFlow::activeWindowChanged(WId w)
{
    if( view() ){
      //  if(view()->winId() != taskManager->getMainWindowId()){
        if(view()->effectiveWinId() != taskManager->getMainWindowId()){
            this->setMainWindowId();

            if(this->containment()){
                KConfigGroup kfg=this->containment()->config();
                QString inDashboard = kfg.readEntry("plugin","---");

                bool res = (inDashboard == "desktopDashboard");

                QMetaObject::invokeMethod(mainQML, "setIsOnDashboard",
                                          Q_ARG(QVariant, res));
            }
        }
    }

}

////INVOKES

QStringList WorkFlow::getWorkAreaNames(QString id)
{
    QStringList *ret = storedWorkareas[id];


    QStringList ret2;
    if(ret){
        for(int i=0; i<ret->size(); i++)
            ret2.append(ret->value(i));
    }
    return ret2;
}

void WorkFlow::addWorkArea(QString id, QString name)
{
    QStringList *ret = storedWorkareas[id];

    if (ret)
        ret->append(name);

    QRectF rf = this->geometry();
    taskManager->setTopXY(rf.x(),rf.y());
}

void WorkFlow::addEmptyActivity(QString id)
{
    QStringList *newLst = new QStringList();
    storedWorkareas[id] = newLst;
    // qDebug()<< this->extender()->winId();
}

void WorkFlow::removeActivity(QString id)
{
    if (storedWorkareas.contains(id)){
        QStringList *ret = storedWorkareas[id];
        ret->clear();

        storedWorkareas.remove(id);
        delete ret;
    }
}

void WorkFlow::renameWorkarea(QString id, int desktop, QString name)
{
    QStringList *ret = storedWorkareas[id];

    if (ret)
        ret->replace(desktop-1,name);
}

void WorkFlow::removeWorkarea(QString id, int desktop)
{
    QStringList *ret = storedWorkareas[id];

    if (ret)
        ret->removeAt(desktop-1);
}

bool WorkFlow::activityExists(QString id)
{
    return storedWorkareas.contains(id);
}


void WorkFlow::saveWorkareas()
{

    QHashIterator<QString, QStringList *> i(storedWorkareas);
    QStringList writeActivities;
    QStringList writeSizes;
    QStringList writeWorkareas;

    while (i.hasNext()) {
        i.next();
        QStringList *curWorks = i.value();
        writeActivities.append(i.key());
        writeSizes.append(QString::number(curWorks->size()));

        for(int j=0; j<curWorks->size(); j++){
            writeWorkareas.append(curWorks->value(j));
        }
    }

    WorkFlowSettings::setActivities(writeActivities);
    WorkFlowSettings::setNoOfWorkareas(writeSizes);
    WorkFlowSettings::setWorkareasNames(writeWorkareas);
    WorkFlowSettings::self()->writeConfig();

}


////Properties


void WorkFlow::setZoomFactor(int zoom)
{
    m_zoomFactor = zoom;
}

void WorkFlow::setShowWindows(bool show)
{
    m_showWindows = show;
    if (!show){
        taskManager->hideWindowsPreviews();
    }
}

void WorkFlow::setLockActivities(bool lock)
{
    m_lockActivities = lock;
}

void WorkFlow::setAnimations(bool anim)
{
    m_animations = anim;
}



//////// Methods
void WorkFlow::loadWorkareas()
{
    storedWorkareas.clear();

    QStringList acts = WorkFlowSettings::activities();
    QStringList lengths = WorkFlowSettings::noOfWorkareas();
    QStringList wnames = WorkFlowSettings::workareasNames();

    for(int i=0; i<acts.size(); i++){
        QString activit = acts[i];

        int intpos = 0;
        for(int j=0; j<i; j++)
            intpos += lengths[j].toInt();

        QStringList *foundWorkAreas = new QStringList();

        for(int k=0; k<lengths[i].toInt(); k++)
            foundWorkAreas->append(wnames[intpos+k]);

        storedWorkareas[activit] = foundWorkAreas;

    }
}




void WorkFlow::loadConfigurationFiles()
{
    bool lockAc = appConfig.readEntry("LockActivities", true);
    bool showW = appConfig.readEntry("ShowWindows", true);
    int zoomF = appConfig.readEntry("ZoomFactor", 50);
    bool anim = appConfig.readEntry("Animations", true);

    setLockActivities(lockAc);
    QMetaObject::invokeMethod(mainQML, "setLockActivities",
                              Q_ARG(QVariant, lockAc));

    setShowWindows(showW);
    QMetaObject::invokeMethod(mainQML, "setShowWindows",
                              Q_ARG(QVariant, showW));

    setZoomFactor(zoomF);
    QMetaObject::invokeMethod(mainQML, "setZoomSlider",
                              Q_ARG(QVariant, zoomF));

    setAnimations(anim);
    QMetaObject::invokeMethod(mainQML, "setAnimations",
                              Q_ARG(QVariant, anim));

}

void WorkFlow::saveConfigurationFiles()
{
    appConfig.writeEntry("LockActivities",m_lockActivities);
    appConfig.writeEntry("ShowWindows",m_showWindows);
    appConfig.writeEntry("ZoomFactor",m_zoomFactor);
    appConfig.writeEntry("Animations",m_animations);

    emit configNeedsSaving();
}



#include "workflow.moc"

