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

#include "ui_workflowConfig.h"
#include "storedparameters.h"

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


#include <iostream>

WorkFlow::WorkFlow(QObject *parent, const QVariantList &args):
    Plasma::PopupApplet(parent, args),
    m_mainWidget(0),
    m_actManager(0),
    m_taskManager(0)
{
    setAspectRatioMode(Plasma::IgnoreAspectRatio);

    setPopupIcon("preferences-activities");

    m_actManager = new ActivityManager(this);
    m_taskManager = new PTaskManager(this);
    m_workareasManager = new WorkareasManager(this);

    m_findPopupWid = false;

    m_isOnDashboard = false;
    m_desktopWidget = qApp->desktop();
}

WorkFlow::~WorkFlow()
{
    if (m_actManager)
        delete m_actManager;
    if (m_taskManager)
        delete m_taskManager;
    if (m_workareasManager)
        delete m_workareasManager;
    if (m_storedParams)
        delete m_storedParams;
}

QGraphicsWidget *WorkFlow::graphicsWidget()
{
    return m_mainWidget;
}

void WorkFlow::init(){
    setHasConfigurationInterface(true);

    m_mainWidget = new QGraphicsWidget(this);

    appConfig = config();

    m_storedParams = new StoredParameters(this,& appConfig);

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
    declarativeWidget->engine()->rootContext()->setContextProperty("storedParameters",m_storedParams);
    declarativeWidget->setQmlPath(path);

    mainLayout->addItem(declarativeWidget);
    m_mainWidget->setLayout(mainLayout);

    if (declarativeWidget->engine()) {
        QDeclarativeContext *ctxt = declarativeWidget->engine()->rootContext();
        if (ctxt) {
            ctxt->setContextProperty("activityManager", m_actManager);
            ctxt->setContextProperty("taskManager", m_taskManager);
            ctxt->setContextProperty("workareasManager", m_workareasManager);
            ctxt->setContextProperty("workflowManager", this);

            QObject *rootObject = dynamic_cast<QObject *>(declarativeWidget->rootObject());
            QObject *qmlActEng = rootObject->findChild<QObject*>("instActivitiesEngine");
            QObject *qmlTaskEng = rootObject->findChild<QObject*>("instTasksEngine");
            mainQML = rootObject;


            if(qmlActEng){

                Plasma::Corona *tCorona=NULL;

                if(containment())
                    if(containment()->corona())
                        tCorona = containment()->corona();

                m_actManager->setQMlObject(qmlActEng, tCorona, this);
                connect(m_actManager,SIGNAL(showedIconDialog()),this,SLOT(showingIconsDialog()));
                connect(m_actManager,SIGNAL(answeredIconDialog()),this,SLOT(answeredIconDialog()));
            }
            if(qmlTaskEng){
                m_taskManager->setQMlObject(qmlTaskEng);
            }

            if(containment())
                m_isOnDashboard = !(containment()->containmentType() == Plasma::Containment::PanelContainment);
        }

    }

    screensSizeChanged(-1); //set Screen Ratio
    setGraphicsWidget(m_mainWidget);

    m_mainWidget->setMinimumSize(550,350);
    setPassivePopupSlot(m_storedParams->hideOnClick());

    connect(this,SIGNAL(geometryChanged()),this,SLOT(geomChanged()));

    connect(KWindowSystem::self(),SIGNAL(activeWindowChanged(WId)),this,SLOT(activeWindowChanged(WId)));

    connect(m_desktopWidget,SIGNAL(resized(int)),this,SLOT(screensSizeChanged(int)));

    connect(m_storedParams,SIGNAL(hideOnClickChanged(bool)), this, SLOT(setPassivePopupSlot(bool)));
    connect(m_storedParams, SIGNAL(configNeedsSaving()), this, SIGNAL(configNeedsSaving()));

    connect(m_workareasManager, SIGNAL(workAreaWasClicked()), this, SLOT(workAreaWasClickedSlot()) );

    connect(m_taskManager, SIGNAL(updatePopWindowWId()), this, SLOT(updatePopWindowWIdSlot()));
    connect(m_taskManager, SIGNAL(hidePopup()), this, SLOT(hidePopupDialogSlot()));

    connect(m_actManager, SIGNAL(hidePopup()), this, SLOT(hidePopupDialogSlot()));

}

void WorkFlow::hidePopupDialogSlot()
{
    this->hidePopup();
}

void WorkFlow::showPopupDialogSlot()
{
    this->showPopup();
}

void WorkFlow::setMainWindowId()
{
    QRectF rf = this->geometry();

    if(m_isOnDashboard)
        m_taskManager->setTopXY(rf.x(),rf.y());
    else
        m_taskManager->setTopXY(0,0);

    m_taskManager->setMainWindowId(view()->effectiveWinId());
}

void WorkFlow::geomChanged()
{
    QRectF rf = this->geometry();

    if(m_isOnDashboard)
        m_taskManager->setTopXY(rf.x(),rf.y());
    else
        m_taskManager->setTopXY(0,0);
}

void WorkFlow::updatePopWindowWIdSlot()
{
    if(m_taskManager->getMainWindowId() == 0){
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
        m_taskManager->setMainWindowId(lastWindow);
        m_taskManager->setTopXY(0,0);
    }
}

void WorkFlow::setPassivePopupSlot(bool passive)
{
    setPassivePopup(!passive);
}

void WorkFlow::popupEvent(bool show)
{
    if((!show)&&(!m_findPopupWid)){
        updatePopWindowWIdSlot();
    }
}

//This slot is just to check the id for the dashboard
//there are circumstances where this id changes very often,
//this id is used for the window previews
void WorkFlow::activeWindowChanged(WId w)
{
    if( m_isOnDashboard && view() && containment()){
        if(view()->effectiveWinId() != m_taskManager->getMainWindowId()){
            this->setMainWindowId();
        }
    }
}

void WorkFlow::workAreaWasClickedSlot()
{
    if(m_storedParams->hideOnClick())
        this->hidePopup();

    if(m_isOnDashboard)
        m_taskManager->hideDashboard();
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
        m_taskManager->showDashboard();
}

void WorkFlow::configChanged()
{
    m_storedParams->configChanged();
}

void WorkFlow::configAccepted()
{
    m_storedParams->setAnimations(ui.animationsLevelSlider->value());
    m_storedParams->setHideOnClick(ui.hideOnClickCheckBox->isChecked());
    m_storedParams->setToolTipsDelay(ui.tooltipsSpinBox->value());

    m_storedParams->setCurrentTheme(ui.themesCmb->currentText());

    emit configNeedsSaving();
}

void WorkFlow::showingIconsDialog()
{
    this->hidePopup();
}

void WorkFlow::answeredIconDialog()
{
    this->showPopup();
}


void WorkFlow::createConfigurationInterface(KConfigDialog *parent)
{
    QWidget *widget = new QWidget();

    ui.setupUi(widget);
    parent->addPage(widget, i18n("General"), icon());

    connect(parent, SIGNAL(applyClicked()), this, SLOT(configAccepted()));
    connect(parent, SIGNAL(okClicked()), this, SLOT(configAccepted()));
    connect(parent, SIGNAL(finished()), this, SLOT(configDialogFinished()));

    ui.animationsLevelSlider->setValue(m_storedParams->animations());
    ui.hideOnClickCheckBox->setChecked(m_storedParams->hideOnClick());

    for(int i=0; i<m_storedParams->themesList()->count(); i++)
        ui.themesCmb->addItem(m_storedParams->themesList()->at(i));

    ui.themesCmb->setCurrentIndex(m_storedParams->themesList()->indexOf(m_storedParams->currentTheme()));
    ui.tooltipsSpinBox->setValue(m_storedParams->toolTipsDelay());

    if(m_isOnDashboard)
        ui.hideOnClickCheckBox->setEnabled(false);

    connect(ui.themesCmb, SIGNAL(activated(int)), parent, SLOT(settingsModified()));
    connect(ui.hideOnClickCheckBox, SIGNAL(stateChanged(int)), parent, SLOT(settingsModified()));
    connect(ui.tooltipsSpinBox, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));
    connect(ui.animationsLevelSlider, SIGNAL(valueChanged(int)), parent, SLOT(settingsModified()));

    //  parent->setModal(true);

}

void WorkFlow::wheelEvent(QGraphicsSceneWheelEvent *e)
{
    if(e->delta() < 0)
        m_actManager->setCurrentNextActivity();
    else
        m_actManager->setCurrentPreviousActivity();
}

#include "workflow.moc"

// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(workflow, WorkFlow)
