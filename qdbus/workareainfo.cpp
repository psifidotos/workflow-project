#include "workareainfo.h"

WorkareaInfo::WorkareaInfo(QString id,QObject *parent) :
    QObject(parent),
    m_id(id),
    m_background("")
{
}

WorkareaInfo::~WorkareaInfo()
{
}

QString WorkareaInfo::id() const
{
    return m_id;
}

QString WorkareaInfo::background() const
{
    return m_background;
}

QString WorkareaInfo::name(int desktop) const
{
    if(m_workareas.size() >= desktop)
        return m_workareas.at(desktop-1);

    return "";
}

QStringList WorkareaInfo::workareas() const
{
    return m_workareas;
}

void WorkareaInfo::setBackground(QString background)
{
    if (m_background != background)
    {
        m_background = background;
        emit workareaInfoUpdated(m_id);
    }
}

int WorkareaInfo::numberOfWorkareas() const
{
    return m_workareas.count();
}

void WorkareaInfo::addWorkArea(QString name)
{
    m_workareas.append(name);

    emit workareaAdded(m_id, name);
}

void WorkareaInfo::removeWorkarea(int desktop)
{
    if(m_workareas.size() >= desktop){
        m_workareas.removeAt(desktop-1);
        emit workareaRemoved(m_id, desktop);
    }
}

void WorkareaInfo::renameWorkarea(int desktop, QString name)
{
    if(m_workareas.size() >= desktop){
        m_workareas.replace(desktop-1,name);

        emit workareaInfoUpdated(m_id);
    }
}

WorkareaInfo *WorkareaInfo::copy(QObject *parent)
{
    WorkareaInfo *copy = new WorkareaInfo(m_id, parent);

    copy->setBackground(m_background);
    foreach (const QString &name, m_workareas)
        copy->m_workareas.append(name);

    return copy;
}

#include "workareainfo.moc"
