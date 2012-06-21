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

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>
#include <QRectF>



#include <Plasma/Extender>
#include <Plasma/ExtenderItem>
#include <Plasma/ToolTipManager>
#include <Plasma/Corona>
#include <Plasma/Containment>
#include <Plasma/Wallpaper>

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

    delete actManager;
    delete taskManager;
}

void WorkFlow::init(){


    Plasma::ToolTipManager::self()->registerWidget(this);

    extender()->setEmptyExtenderMessage(i18n("No Activities..."));
    // don't grow too much height
    //extender()->setMaximumHeight(300);
    if (extender()->item("WorkFlow") == 0) {
        // create the item
        Plasma::ExtenderItem *item = new Plasma::ExtenderItem(extender());
        // initialize the item
        initExtenderItem(item);
        // set item name and title
        item->setName("WorkFlow");
        item->setTitle("WorkFlow");

        QString wD = appConfig.readEntry("PopupWidth", "550");
        QString hD = appConfig.readEntry("PopupHeight", "300");
        //item->resize(wD.toFloat(),hD.toFloat());
        extender()->resize(wD.toFloat(),hD.toFloat());
    }


}

void WorkFlow::initExtenderItem(Plasma::ExtenderItem *item) {

    m_mainWidget = new QGraphicsWidget(this);

    appConfig = config();

    QString wD = appConfig.readEntry("PopupWidth", "550");
    QString hD = appConfig.readEntry("PopupHeight", "300");

    m_mainWidget->setPreferredSize(wD.toFloat(), hD.toFloat());
    //m_mainWidget->setMinimumSize(200,200);

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


            if(!rootObject)
                qDebug() << "root was not found...";
            else{
                if(qmlActEng)
                    actManager->setQMlObject(qmlActEng, dataEngine("org.kde.activities"));
                if(qmlTaskEng)
                    taskManager->setQMlObject(qmlTaskEng, dataEngine("tasks"));
            }

            loadConfigurationFiles();
        }
    }

    //the activitymanager class will be directly accessible from qml

    item->setWidget(m_mainWidget);


    connect(item,SIGNAL(geometryChanged()),this,SLOT(geomChanged()));

    m_mainWidget->resize(wD.toFloat(),hD.toFloat());
}
///SLOTS

void WorkFlow::geomChanged()
{
    QRectF rf = m_mainWidget->geometry();

    appConfig.writeEntry("PopupWidth",rf.width());
    appConfig.writeEntry("PopupHeight",rf.height());

    emit configNeedsSaving();

    /*
    WorkFlowSettings::setWidth(rf.width());
    WorkFlowSettings::setHeight(rf.height());
    WorkFlowSettings::self()->writeConfig();*/
}

////INVOKES

////Properties


void WorkFlow::setZoomFactor(int zoom)
{
    m_zoomFactor = zoom;
}

void WorkFlow::setShowWindows(bool show)
{
    m_showWindows = show;
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

