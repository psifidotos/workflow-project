#include "syncactivitiesworkareas.h"

#include <KWindowSystem>
#include <QDebug>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

SyncActivitiesWorkareas::SyncActivitiesWorkareas(QObject *obj) :
    QObject(obj),
    m_desktops(0),
    m_workareas(0)
{
    init();
}

SyncActivitiesWorkareas::~SyncActivitiesWorkareas()
{
}

void SyncActivitiesWorkareas::init()
{
    m_desktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();

    connect(KWindowSystem::KWindowSystem::self(), SIGNAL(numberOfDesktopsChanged(int)),
            this, SLOT(numberOfDesktopsChangedSlot(int)) );
}

void SyncActivitiesWorkareas::maxWorkareasUpdated(int maxWorkareas)
{
    m_workareas = maxWorkareas;
    if (maxWorkareas>m_desktops)
        addDesktop();
    else if (maxWorkareas<m_desktops)
        removeDesktop();
}

void SyncActivitiesWorkareas::numberOfDesktopsChangedSlot(int desktops)
{
    m_desktops = desktops;
    if (m_desktops > m_workareas)
        removeDesktop();
    else if (m_desktops < m_workareas)
        addDesktop();
}


#ifdef Q_WS_X11
void SyncActivitiesWorkareas::addDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    info.setNumberOfDesktops(info.numberOfDesktops() + 1);
}

void SyncActivitiesWorkareas::removeDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    int desktops = info.numberOfDesktops();
    if (desktops > 1) {
        info.setNumberOfDesktops(info.numberOfDesktops() - 1);
    }
}
#endif

#include "syncactivitiesworkareas.moc"
