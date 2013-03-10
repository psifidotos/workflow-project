#include "mechanismupdateworkareasname.h"

#include <KWindowSystem>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

MechanismUpdateWorkareasName::MechanismUpdateWorkareasName(QObject *obj) :
    QObject(obj),
    m_desktops(0)
{
    init();
}

MechanismUpdateWorkareasName::~MechanismUpdateWorkareasName()
{
}

void MechanismUpdateWorkareasName::init()
{
    m_desktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();

    connect(KWindowSystem::KWindowSystem::self(), SIGNAL(numberOfDesktopsChanged(int)),
            this, SLOT(numberOfDesktopsChangedSlot(int)) );
}

/*
void MechanismUpdateWorkareasName::checkFlag(int workarea)
{
    if (workarea>m_desktops)
        m_awaitingName = true;
    else
        m_awaitingName = false;
}*/

void MechanismUpdateWorkareasName::numberOfDesktopsChangedSlot(int desktops)
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

#include "mechanismupdateworkareasname.moc"
