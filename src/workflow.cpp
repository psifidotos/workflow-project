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
#include <QRectF>
#include <QString>

#include <Plasma/Extender>
#include <Plasma/ExtenderItem>
#include <Plasma/ToolTipManager>
#include <Plasma/Containment>
#include <Plasma/PackageStructure>
#include <Plasma/Package>
#include <Plasma/Corona>

#include "parametersmanager.h"

WorkFlow::WorkFlow(QObject *parent, const QVariantList &args):
    Plasma::PopupApplet(parent, args),
    m_mainWidget(0),
    actManager(0),
    taskManager(0)
{
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
    setPassivePopup(true);
    setHasConfigurationInterface(true);
    setPopupIcon("preferences-activities");

    actManager = new ActivityManager(this);
    taskManager = new PTaskManager(this);

  //  m_animations = 1;
    m_findPopupWid = false;

//    m_windowsPreviews=false;
  //  m_windowsPreviewsOffsetX=0;
 //   m_windowsPreviewsOffsetY=0;
    m_fontRelevance=0;
    m_showStoppedActivities=true;
    m_firstRunLiveTour=false;
    m_firstRunCalibrationPreviews=false;
    m_hideOnClick = false;

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
    if (paramManager)
        delete paramManager;
}

QGraphicsWidget *WorkFlow::graphicsWidget()
{
    return m_mainWidget;
}

void WorkFlow::init(){
    m_mainWidget = new QGraphicsWidget(this);

    appConfig = config();

    paramManager = new ParametersManager(this,&appConfig);

    mainLayout = new QGraphicsLinearLayout(m_mainWidget);
    mainLayout->setOrientation(Qt::Vertical);
    mainLayout->setContentsMargins(0, 0, 0, 0);
    mainLayout->setSpacing(0);

    Plasma::PackageStructure::Ptr structure = Plasma::Applet::packageStructure();
    const QString workflowPath = KGlobal::dirs()->locate("data", structure->defaultPackageRoot() + "/workflow/");
    Plasma::Package package(workflowPath, structure);
    QString path = package.filePath("mainscript");

    kDebug() << "Path: " << path << endl;

    declarativeWidget = new Plasma::DeclarativeWidget();
    declarativeWidget->engine()->rootContext()->setContextProperty("parametersManager",paramManager);
    declarativeWidget->setQmlPath(path);

    connect(paramManager, SIGNAL(configNeedsSaving()), this, SIGNAL(configNeedsSaving()));

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
            }

            QMetaObject::invokeMethod(mainQML, "loadThemes");

            loadConfigurationFiles();
        }
    }

    screensSizeChanged(-1); //set Screen Ratio

    connect(this,SIGNAL(geometryChanged()),this,SLOT(geomChanged()));
    connect(m_desktopWidget,SIGNAL(resized(int)),this,SLOT(screensSizeChanged(int)));
    connect(KWindowSystem::self(),SIGNAL(activeWindowChanged(WId)),this,SLOT(activeWindowChanged(WId)));

    m_mainWidget->setMinimumSize(550,350);
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
    if( view() ){
        //  if(view()->winId() != taskManager->getMainWindowId()){

        if(containment()){
            KConfigGroup kfg=this->containment()->config();
            QString inDashboard = kfg.readEntry("plugin","---");

            m_isOnDashboard = (inDashboard == "desktopDashboard");

            QMetaObject::invokeMethod(mainQML, "setIsOnDashboard",
                                      Q_ARG(QVariant, m_isOnDashboard));

            if(m_isOnDashboard){
                if(view()->effectiveWinId() != taskManager->getMainWindowId()){
                    this->setMainWindowId();
                }
            }
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
/*
void WorkFlow::setAnimations(int anim)
{
    m_animations = anim;
    QMetaObject::invokeMethod(mainQML, "setAnimations", Q_ARG(QVariant, anim));
    appConfig.writeEntry("Animations",m_animations);
    emit configNeedsSaving();
}
*/
void WorkFlow::setHideOnClick(bool h)
{
    m_hideOnClick = h;
    setPassivePopup(!h);
}

void WorkFlow::workAreaWasClicked()
{
    if(m_hideOnClick)
        this->hidePopup();
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
    paramManager->setAnimations(m_config.animationsLevelSlider->value());
    setHideOnClickSlot(m_config.hideOnClickCheckBox->isChecked());
    themeSelectionChanged(m_config.themesCmb->currentText());
    setToolTipsDelayChanged(m_config.tooltipsSpinBox->value());
}

void WorkFlow::showingIconsDialog()
{
    this->hidePopup();
}

void WorkFlow::answeredIconDialog()
{
    this->showPopup();
}

void WorkFlow::setFontRelevance(bool fr){
    m_fontRelevance = fr;
    QMetaObject::invokeMethod(mainQML, "setFontRelevance", Q_ARG(QVariant, fr));
    appConfig.writeEntry("FontRelevance", fr);
    emit configNeedsSaving();
}

void WorkFlow::setShowStoppedActivities(bool s){
    m_showStoppedActivities = s;
    QMetaObject::invokeMethod(mainQML, "setShowStoppedActivities", Q_ARG(QVariant, s));
    appConfig.writeEntry("ShowStoppedPanel", s);
    emit configNeedsSaving();
}

void WorkFlow::setFirstRunLiveTour(bool f){
    m_firstRunLiveTour = f;
    QMetaObject::invokeMethod(mainQML, "setFirstRunLiveTour", Q_ARG(QVariant, f));
    appConfig.writeEntry("FirstRunTour", f);
    emit configNeedsSaving();
}

void WorkFlow::setFirstRunCalibrationPreviews(bool cal){
    m_firstRunCalibrationPreviews = cal;
    appConfig.writeEntry("FirstRunCalibration", cal);
    emit configNeedsSaving();
}

void WorkFlow::setCurrentTheme(QString theme)
{
    m_currentTheme = theme;
    QMetaObject::invokeMethod(mainQML, "setCurrentTheme", Q_ARG(QVariant, theme));
    appConfig.writeEntry("CurrentTheme", theme);
    emit configNeedsSaving();
}

void WorkFlow::setToolTipsDelayChanged(int val)
{
    m_tipsDelay = val;
    QMetaObject::invokeMethod(mainQML, "setToolTipsDelay", Q_ARG(QVariant, val));
    appConfig.writeEntry("ToolTipsDelay", val);
    emit configNeedsSaving();
}

void WorkFlow::addTheme(QString theme)
{
    loadedThemes.append(theme);
}

void WorkFlow::themeSelectionChanged(QString th){
    setCurrentTheme(th);
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

void WorkFlow::loadConfigurationFiles()
{
  //  int zoomF = appConfig.readEntry("ZoomFactor", 50);
 //   int anim = appConfig.readEntry("Animations", true);
//    bool winPreviews = appConfig.readEntry("WindowPreviews", false);
 //   int winPrevOffX = appConfig.readEntry("WindowPreviewsOffsetX", 0);
 //   int winPrevOffY = appConfig.readEntry("WindowPreviewsOffsetY", 0);
    int fontRel = appConfig.readEntry("FontRelevance", 0);
    bool showStopAct = appConfig.readEntry("ShowStoppedPanel", true);
    bool firRunLiveTour = appConfig.readEntry("FirstRunTour", false);
    bool firRunCalibrationPrev = appConfig.readEntry("FirstRunCalibration", false);
    bool hideOnClick = appConfig.readEntry("HideOnClick", false);
    QString curTheme = appConfig.readEntry("CurrentTheme", "Oxygen");
    int tipsDelay = appConfig.readEntry("ToolTipsDelay", 300);

 //   setZoomFactor(zoomF);
//    setAnimations(anim);
 //   setWindowsPreviews(winPreviews);
  //  setWindowsPreviewsOffsetX(winPrevOffX);
 //   setWindowsPreviewsOffsetY(winPrevOffY);
    setFontRelevance(fontRel);
    setShowStoppedActivities(showStopAct);
    setFirstRunLiveTour(firRunLiveTour);
    setFirstRunCalibrationPreviews(firRunCalibrationPrev);
    setHideOnClick(hideOnClick);
    setCurrentTheme(curTheme);
    setToolTipsDelayChanged(tipsDelay);
}
/*
void WorkFlow::setAnimationsSlot(int val){
    this->setAnimations(val);
}

*/
void WorkFlow::setHideOnClickSlot(bool h)
{
    this->setHideOnClick(h);
    appConfig.writeEntry("HideOnClick", h);
    emit configNeedsSaving();
}

void WorkFlow::createConfigurationInterface(KConfigDialog *parent)
{
    QWidget *widget = new QWidget(parent);

    m_config.setupUi(widget);
    parent->addPage(widget, i18n("General"), icon(), QString(), false);
    //m_config.animationsLevelSlider->setValue(m_animations);
    m_config.animationsLevelSlider->setValue(paramManager->animations());
    m_config.hideOnClickCheckBox->setChecked(m_hideOnClick);

    for(int i=0; i<loadedThemes.count(); i++)
        m_config.themesCmb->addItem(loadedThemes.at(i));

    m_config.themesCmb->setCurrentIndex(loadedThemes.indexOf(m_currentTheme));
    m_config.tooltipsSpinBox->setValue(m_tipsDelay);

    if(m_isOnDashboard)
        m_config.hideOnClickCheckBox->setEnabled(false);

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

int WorkFlow::setCurrentActivityAndDesktop(QString actid,int desk)
{
    actManager->setCurrent(actid);
    int nextDesk = desk;
    int actSize = this->activitySize(actid);

    if(desk>actSize)
        nextDesk = actSize;

    taskManager->setCurrentDesktop(nextDesk);
    return nextDesk;
}

// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(workflow,WorkFlow);

#include "workflow.moc"


