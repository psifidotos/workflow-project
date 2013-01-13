#include "pluginsyncactivitiesworkareas.h"

#include <KWindowSystem>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

PluginSyncActivitiesWorkareas::PluginSyncActivitiesWorkareas(QObject *obj) :
    QObject(obj),
    m_desktops(0),
    m_workareas(0)
{
    init();
}

PluginSyncActivitiesWorkareas::~PluginSyncActivitiesWorkareas()
{
}

void PluginSyncActivitiesWorkareas::init()
{
    m_desktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();

    connect(KWindowSystem::KWindowSystem::self(), SIGNAL(numberOfDesktopsChanged(int)),
            this, SLOT(numberOfDesktopsChangedSlot(int)) );
}

void PluginSyncActivitiesWorkareas::maxWorkareasUpdated(int maxWorkareas)
{
    m_workareas = maxWorkareas;
    if (maxWorkareas>m_desktops)
        addDesktop();
    else if (maxWorkareas<m_desktops)
        removeDesktop();
}

void PluginSyncActivitiesWorkareas::numberOfDesktopsChangedSlot(int desktops)
{
    m_desktops = desktops;
    if (m_desktops > m_workareas)
        removeDesktop();
    else if (m_desktops < m_workareas)
        addDesktop();

}


#ifdef Q_WS_X11
void PluginSyncActivitiesWorkareas::addDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    info.setNumberOfDesktops(info.numberOfDesktops() + 1);
}

void PluginSyncActivitiesWorkareas::removeDesktop()
{
    NETRootInfo info(QX11Info::display(), NET::NumberOfDesktops);
    int desktops = info.numberOfDesktops();
    if (desktops > 1) {
        info.setNumberOfDesktops(info.numberOfDesktops() - 1);
    }
}
#endif



#include "pluginsyncactivitiesworkareas.moc"
