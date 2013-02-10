#include "plasmoidwrapper.h"

#include <QGraphicsView>
#include <QDebug>

#include <KWindowSystem>
#include <KStandardDirs>

#include <Plasma/Applet>
#include <Plasma/Containment>
#include <Plasma/Extender>
#include <Plasma/PackageStructure>
#include <Plasma/Package>
#include <Plasma/PopupApplet>

PlasmoidWrapper::PlasmoidWrapper(QObject *parent) :
    QObject(parent),
    m_isInPanel(false),
    m_findPopupWid(false),
    m_windowID(""),
    m_version(""),
    m_wPosition(-1),
    m_popupApplet(0)
{
}

PlasmoidWrapper::~PlasmoidWrapper()
{
}

void PlasmoidWrapper::setApplet(QObject *extender)
{
    Plasma::Extender *appletExtender = static_cast<Plasma::Extender *>(extender);

    if(appletExtender){
        Plasma::Applet *applet = appletExtender->applet();
        if(applet){

            Plasma::PackageStructure::Ptr structure = Plasma::Applet::packageStructure();
            const QString workflowPath = KGlobal::dirs()->locate("data", structure->defaultPackageRoot() + "/workflow/");
            Plasma::Package package(workflowPath, structure);

            m_version = package.metadata().version();
            emit versionChanged(m_version);

            m_popupApplet = static_cast<Plasma::PopupApplet *>(applet);

            if(m_popupApplet->containment()){
                m_isInPanel = (m_popupApplet->containment()->containmentType() == Plasma::Containment::PanelContainment);
                emit isInPanelChanged(m_isInPanel);

                connect(m_popupApplet,SIGNAL(geometryChanged()),this,SLOT(geometryChangedSlot()));

                connect(KWindowSystem::self(),SIGNAL(activeWindowChanged(WId)),this,SLOT(activeWindowChangedSlot(WId)));
            }
        }

        delete extender;
    }
}


void PlasmoidWrapper::geometryChangedSlot()
{
    if(m_popupApplet){
        QRectF rf = m_popupApplet->geometry();

        if(m_isInPanel)
            emit updateMarginForPreviews(0,0);
        else
            emit updateMarginForPreviews(rf.x(),rf.y());
    }
}

int PlasmoidWrapper::currentWIdPosition()
{
    return (m_wPosition+1);
}

void PlasmoidWrapper::nextWId()
{
    m_wPosition--;
    if(m_wPosition <= -1)
        m_wPosition = KWindowSystem::windows().size() - 1;

    updateMainWId();
}


void PlasmoidWrapper::updateMainWId()
{
    WId lastWindow = 0;

    //The first time the pop up is shown , then it is the last window
    // in windows list in KWindowSystem
    if( (m_wPosition<0) || (m_wPosition>=KWindowSystem::windows().size()) )
        m_wPosition = KWindowSystem::windows().size() - 1;

    lastWindow = KWindowSystem::windows()[m_wPosition];

    m_findPopupWid = true;
    m_windowID = QString::number(lastWindow);

    emit updateWindowIDForPreviews(m_windowID);
    emit updateMarginForPreviews(0,0);
}

void PlasmoidWrapper::updatePopWindowWIdSlot()
{
    if(m_popupApplet && (m_windowID == "") ){
       updateMainWId();
    }
}

void PlasmoidWrapper::popupEventSlot(bool show)
{
    if((!show)&&(!m_findPopupWid))
        updatePopWindowWIdSlot();
}

//This slot is just to check the id for the dashboard
//there are circumstances where this id changes very often,
//this id is used for the window previews
void PlasmoidWrapper::activeWindowChangedSlot(WId w)
{
    Q_UNUSED(w);

    if( !m_isInPanel && m_popupApplet && m_popupApplet->view() ){
        if(QString::number(m_popupApplet->view()->effectiveWinId()) != m_windowID )
            setMainWindowId();
    }
}


void PlasmoidWrapper::setMainWindowId()
{
    if(m_popupApplet){
        QRectF rf = m_popupApplet->geometry();

        if(m_isInPanel)
            emit updateMarginForPreviews(0,0);
        else
            emit updateMarginForPreviews(rf.x(),rf.y());

        m_windowID = QString::number(m_popupApplet->view()->effectiveWinId());
        emit updateWindowIDForPreviews( m_windowID );
    }
}


bool PlasmoidWrapper::isPopupShowing()
{
    return m_popupApplet->isPopupShowing();
}

#include "plasmoidwrapper.moc"
