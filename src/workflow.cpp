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

#include "ui_config.h"
#include "workflowsettings.h"

#include <KDebug>
#include <KGlobalSettings>
#include <KConfigGroup>
#include <KConfigDialog>
#include <KSharedConfig>
#include <KWindowSystem>

#include <QDeclarativeContext>
#include <QDeclarativeEngine>
#include <QDeclarativeComponent>
#include <QDesktopWidget>
#include <QGraphicsView>
#include <QGraphicsSceneWheelEvent>
#include <QGraphicsLinearLayout>
#include <QRectF>
#include <QString>

#include <Plasma/Containment>
#include <Plasma/PackageStructure>
#include <Plasma/Package>
#include <Plasma/Corona>

#include "storedparameters.h"
#include <iostream>

WorkFlow::WorkFlow(QObject *parent, const QVariantList &args):
    Plasma::PopupApplet(parent, args),
    m_mainWidget(0),
    actManager(0),
    taskManager(0)
{
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setHasConfigurationInterface(true);
    setPopupIcon("preferences-activities");

    actManager = new ActivityManager(this);
    taskManager = new PTaskManager(this);

    m_findPopupWid = false;

    m_isOnDashboard = false;
    m_desktopWidget = qApp->desktop();
}

WorkFlow::~WorkFlow()
{
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

    if (actManager)
        delete actManager;
    if (taskManager)
        delete taskManager;
    if (storedParams)
        delete storedParams;
}

QGraphicsWidget *WorkFlow::graphicsWidget()
{
    return m_mainWidget;
}

void WorkFlow::init(){
    m_mainWidget = new QGraphicsWidget(this);

    appConfig = config();

    storedParams = new StoredParameters(this,&appConfig);

    QGraphicsLinearLayout *mainLayout = new QGraphicsLinearLayout(m_mainWidget);
    mainLayout->setOrientation(Qt::Vertical);
    mainLayout->setContentsMargins(0, 0, 0, 0);
    mainLayout->setSpacing(0);

    Plasma::PackageStructure::Ptr structure = Plasma::Applet::packageStructure();
    const QString workflowPath = KGlobal::dirs()->locate("data", structure->defaultPackageRoot() + "/workflow/");
    Plasma::Package package(workflowPath, structure);
    QString path = package.filePath("mainscript");

    kDebug() << "Path: " << path << endl;

    declarativeWidget = new Plasma::DeclarativeWidget();
    declarativeWidget->engine()->rootContext()->setContextProperty("storedParameters",storedParams);
    declarativeWidget->setQmlPath(path);

    connect(storedParams, SIGNAL(configNeedsSaving()), this, SIGNAL(configNeedsSaving()));

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


            if(qmlActEng){

                Plasma::Corona *tCorona=NULL;

                if(containment())
                    if(containment()->corona())
                        tCorona = containment()->corona();

                actManager->setQMlObject(qmlActEng, tCorona, this);
                connect(actManager,SIGNAL(showedIconDialog()),this,SLOT(showingIconsDialog()));
                connect(actManager,SIGNAL(answeredIconDialog()),this,SLOT(answeredIconDialog()));
            }
            if(qmlTaskEng){
                taskManager->setQMlObject(qmlTaskEng);
            }

            if(containment())
                m_isOnDashboard = !(containment()->containmentType() == Plasma::Containment::PanelContainment);
        }

    }

    screensSizeChanged(-1); //set Screen Ratio


    connect(this,SIGNAL(geometryChanged()),this,SLOT(geomChanged()));
    connect(m_desktopWidget,SIGNAL(resized(int)),this,SLOT(screensSizeChanged(int)));
    connect(KWindowSystem::self(),SIGNAL(activeWindowChanged(WId)),this,SLOT(activeWindowChanged(WId)));

    m_mainWidget->setMinimumSize(550,350);
    setPassivePopupSlot(storedParams->hideOnClick());
    connect(storedParams,SIGNAL(hideOnClickChanged(bool)), this, SLOT(setPassivePopupSlot(bool)));
}

void WorkFlow::hidePopupDialog()
{
    this->hidePopup();
}

void WorkFlow::showPopupDialog()
{
    this->showPopup();
}

void WorkFlow::setMainWindowId()
{
    QRectF rf = this->geometry();

    if(m_isOnDashboard)
        taskManager->setTopXY(rf.x(),rf.y());
    else
        taskManager->setTopXY(0,0);

    taskManager->setMainWindowId(view()->effectiveWinId());
}

void WorkFlow::geomChanged()
{
    QRectF rf = this->geometry();

    if(m_isOnDashboard)
        taskManager->setTopXY(rf.x(),rf.y());
    else
        taskManager->setTopXY(0,0);
}

void WorkFlow::updatePopWindowWId()
{
    if(taskManager->getMainWindowId() == 0){
        WId lastWindow = 0;

        QList<WId>::ConstIterator it;
        //The first time the pop up is shown , then it is the last window
        // in windows list in KWindowSystem
        for ( it = KWindowSystem::windows().begin();
              it != KWindowSystem::windows().end(); ++it ) {
            if(KWindowSystem::hasWId(*it)){
                lastWindow = *it;
            }
        }

        m_findPopupWid = true;
        taskManager->setMainWindowId(lastWindow);
        taskManager->setTopXY(0,0);
    }
}

void WorkFlow::setPassivePopupSlot(bool passive)
{
    setPassivePopup(!passive);
}

void WorkFlow::popupEvent(bool show)
{
    if((!show)&&(!m_findPopupWid)){
        updatePopWindowWId();
    }
}

//This slot is just to check the id for the dashboard
//there are circumstances where this id changes very often,
//this id is used for the window previews
void WorkFlow::activeWindowChanged(WId w)
{
    if( m_isOnDashboard && view() && containment()){
        if(view()->effectiveWinId() != taskManager->getMainWindowId()){
            this->setMainWindowId();
        }
    }
}

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

int WorkFlow::activitySize(QString id)
{
    QStringList *ret = storedWorkareas[id];
    if (ret)
        return ret->size();
    else
        return 0;
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


void WorkFlow::workAreaWasClicked()
{
    if(storedParams->hideOnClick())
        this->hidePopup();

    if(m_isOnDashboard)
        taskManager->hideDashboard();
}

void WorkFlow::screensSizeChanged(int s)
{
    QRect screenRect = m_desktopWidget->screenGeometry(s);
    float ratio = (float)screenRect.height()/(float)screenRect.width();
    QMetaObject::invokeMethod(mainQML, "setScreenRatio",
                              Q_ARG(QVariant, ratio));

}

void WorkFlow::configDialogFinished()
{
    if(m_isOnDashboard)
        taskManager->showDashboard();
}

void WorkFlow::configDialogAccepted()
{
    //setAnimationsSlot(m_config.animationsLevelSlider->value());
    storedParams->setAnimations(m_config.animationsLevelSlider->value());
    storedParams->setHideOnClick(m_config.hideOnClickCheckBox->isChecked());
    storedParams->setToolTipsDelay(m_config.tooltipsSpinBox->value());

    storedParams->setCurrentTheme(m_config.themesCmb->currentText());
}

void WorkFlow::showingIconsDialog()
{
    this->hidePopup();
}

void WorkFlow::answeredIconDialog()
{
    this->showPopup();
}

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

void WorkFlow::createConfigurationInterface(KConfigDialog *parent)
{
    QWidget *widget = new QWidget();

    m_config.setupUi(widget);
    parent->addPage(widget, i18n("General"), icon(), QString(), false);
    //m_config.animationsLevelSlider->setValue(m_animations);
    m_config.animationsLevelSlider->setValue(storedParams->animations());
    m_config.hideOnClickCheckBox->setChecked(storedParams->hideOnClick());

    for(int i=0; i<storedParams->themesList()->count(); i++)
        m_config.themesCmb->addItem(storedParams->themesList()->at(i));

    m_config.themesCmb->setCurrentIndex(storedParams->themesList()->indexOf(storedParams->currentTheme()));
    m_config.tooltipsSpinBox->setValue(storedParams->toolTipsDelay());

    if(m_isOnDashboard)
        m_config.hideOnClickCheckBox->setEnabled(false);

    connect(m_config.themesCmb, SIGNAL(activated(int)), parent, SLOT(settingsModified()));
    connect(m_config.hideOnClickCheckBox, SIGNAL(stateChanged(int)), parent, SLOT(settingsModified()));
    connect(m_config.tooltipsSpinBox, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));
    connect(m_config.animationsLevelSlider, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));

    connect(parent, SIGNAL(applyClicked()), this, SLOT(configDialogAccepted()));
    connect(parent, SIGNAL(okClicked()), this, SLOT(configDialogAccepted()));
    connect(parent, SIGNAL(finished()), this, SLOT(configDialogFinished()));

    parent->setModal(true);
}

void WorkFlow::wheelEvent(QGraphicsSceneWheelEvent *e)
{
    if(e->delta() < 0)
        actManager->setCurrentNextActivity();
    else
        actManager->setCurrentPreviousActivity();
}

// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(workflow,WorkFlow);

#include "workflow.moc"


