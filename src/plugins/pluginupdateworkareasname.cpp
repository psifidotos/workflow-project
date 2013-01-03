#include "pluginupdateworkareasname.h"

#include <KWindowSystem>

#ifdef Q_WS_X11
#include <QX11Info>
#include <NETRootInfo>
#include <X11/Xlib.h>
#include <fixx11h.h>
#endif

PluginUpdateWorkareasName::PluginUpdateWorkareasName(QObject *obj) :
    QObject(obj),
    m_desktops(0)
{
    init();
}

PluginUpdateWorkareasName::~PluginUpdateWorkareasName()
{
}

void PluginUpdateWorkareasName::init()
{
    m_desktops = KWindowSystem::KWindowSystem::self()->numberOfDesktops();

    connect(KWindowSystem::KWindowSystem::self(), SIGNAL(numberOfDesktopsChanged(int)),
            this, SLOT(numberOfDesktopsChangedSlot(int)) );
}

void PluginUpdateWorkareasName::checkFlag(int workarea)
{
    if (workarea>m_desktops)
        m_awaitingName = true;
    else
        m_awaitingName = false;
}

void PluginUpdateWorkareasName::numberOfDesktopsChangedSlot(int desktops)
{

    if( (m_awaitingName) &&
        (desktops > m_desktops))
    {
        emit updateWorkareasName(desktops);
        m_awaitingName = false;
    }

    m_desktops = desktops;

}

#include "pluginupdateworkareasname.moc"
