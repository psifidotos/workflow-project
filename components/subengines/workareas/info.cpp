#include "info.h"

namespace Workareas{

Info::Info(QString id,QObject *parent) :
    QObject(parent),
    m_id(id),
    m_background("")
{
}

Info::~Info()
{
}

QString Info::id() const
{
    return id();
}

QString Info::background() const
{
    return m_background;
}

QString Info::name(int desktop) const
{
    if(m_workareas.size() >= desktop)
        return m_workareas.at(desktop-1);

    return "";
}

QStringList Info::workareas() const
{
    return m_workareas;
}

void Info::setBackground(QString background)
{
    if (m_background != background)
    {
        m_background = background;
        emit workareaInfoUpdated(m_id);
    }
}

int Info::numberOfWorkareas() const
{
    return m_workareas.count();
}

void Info::addWorkArea(QString name)
{
    m_workareas.append(name);

    emit workareaAdded(m_id, name);
}

void Info::removeWorkarea(int desktop)
{
    if(m_workareas.size() >= desktop){
        m_workareas.removeAt(desktop-1);
        emit workareaRemoved(m_id, desktop);
    }
}

void Info::renameWorkarea(int desktop, QString name)
{
    if(m_workareas.size() >= desktop){
        m_workareas.replace(desktop-1,name);

        emit workareaInfoUpdated(m_id);
    }
}

Workareas::Info *Info::copy(QObject *parent)
{
    Workareas::Info *copy = new Workareas::Info(m_id, parent);

    copy->setBackground(m_background);
    foreach (const QString &name, m_workareas)
        copy->m_workareas.append(name);

    return copy;
}

}

#include "info.moc"
