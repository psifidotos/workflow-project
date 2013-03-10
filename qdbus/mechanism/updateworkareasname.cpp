#include "updateworkareasname.h"

#include <KWindowSystem>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

UpdateWorkareasName::UpdateWorkareasName(QObject *obj) :
    QObject(obj),
    m_desktops(0)
{
    init();
}

UpdateWorkareasName::~UpdateWorkareasName()
{
}

void UpdateWorkareasName::init()
{
    m_desktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();

    connect(KWindowSystem::KWindowSystem::self(), SIGNAL(numberOfDesktopsChanged(int)),
            this, SLOT(numberOfDesktopsChangedSlot(int)) );
}

/*
void UpdateWorkareasName::checkFlag(int workarea)
{
    if (workarea>m_desktops)
        m_awaitingName = true;
    else
        m_awaitingName = false;
}*/

void UpdateWorkareasName::numberOfDesktopsChangedSlot(int desktops)
{

 //   if( (m_awaitingName) &&
  //      (desktops > m_desktops))
  //  {
    if(desktops > m_desktops)
        emit updateWorkareasName(desktops);
   //     m_awaitingName = false;
  //  }

    m_desktops = desktops;

}

#include "updateworkareasname.moc"
