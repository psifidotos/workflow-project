#include "taskitem.h"
#include "listitem.h"

TaskItem::TaskItem(const QString &code,
                   const bool &onAllDesktops,
                   const bool &onAllActivities,
                   const QString &classClass,
                   const QString &name,
                   const QIcon &icon,
                   const int &desktop,
                   const QStringList &activities,
                   QObject *parent):
    ListItem(parent),
    m_code(code),
    m_onAllDesktops(onAllDesktops),
    m_onAllActivities(onAllActivities),
    m_classClass(classClass),
    m_name(name),
    m_icon(icon),
    m_desktop(desktop),
    m_activities(activities)
{
}

TaskItem::~TaskItem()
{
}

TaskItem *TaskItem::copy(QObject *parent)
{
    TaskItem *res = new TaskItem(code(),
                                 onAllDesktops(),
                                 onAllActivities(),
                                 classClass(),
                                 name(),
                                 icon(),
                                 desktop(),
                                 activities(),
                                 parent);
    return res;
}

void TaskItem::setProperty(QString role,QVariant value)
{
    QHash<int, QByteArray> names = roleNames();

    //    if(role == names[CodeRole])
    //        setCode(value.toString());
    //    if(role == names[OnAllDesktopsRole])
    //        setOnAllDesktops(value.toBool());
    //    else if(role == names[OnAllActivitiesRole])
    //       setOnAllActivities(value.toBool());
    //    else if(role == names[ClassClassRole])
    //       setClassClass(value.toString());
    //    else if(role == names[NameRole])
    //        setName(value.toString());
    //    else if(role == names[IconRole])
    //        setIcon(value.toString());
    //    else if(role == names[DesktopRole])
    //        setDesktop(value.toInt());
    //    else if(role == names[ActivitiesRole])
    //        setActivities(value.toStringList());
}

void TaskItem::setCode(QString code)
{
    if(m_code != code){
        m_code = code;
        emit dataChanged();
    }
}
void TaskItem::setName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }
}

void TaskItem::setIcon(QIcon icon)
{
    //if(m_icon != icon){
    m_icon = icon;
    emit dataChanged();
    //}
}

void TaskItem::setOnAllDesktops(bool onAllDesktops)
{
    if(m_onAllDesktops != onAllDesktops){
        m_onAllDesktops = onAllDesktops;
        emit dataChanged();
    }
}

void TaskItem::setOnAllActivities(bool onAllActivities)
{
    if(m_onAllActivities != onAllActivities){
        m_onAllActivities = onAllActivities;
        emit dataChanged();
    }
}

void TaskItem::setClassClass(QString classClass)
{
    if(m_classClass != classClass){
        m_classClass = classClass;
        emit dataChanged();
    }
}

void TaskItem::setDesktop(int desktop)
{
    if(m_desktop != desktop){
        m_desktop = desktop;
        emit dataChanged();
    }
}

void TaskItem::setActivities(QStringList activities)
{
    if(m_activities != activities){
        m_activities = activities;
        emit dataChanged();
    }
}


QHash<int, QByteArray> TaskItem::roleNames() const
{
    QHash<int, QByteArray> names;
    names[CodeRole] = "code";
    names[OnAllDesktopsRole] = "onAllDesktops";
    names[OnAllActivitiesRole] = "onAllActivities";
    names[ClassClassRole] = "classClass";
    names[NameRole] = "name";
    names[IconRole] = "Icon";
    names[DesktopRole] = "desktop";
    names[ActivitiesRole] = "activities";
    return names;
}

QVariant TaskItem::data(int role) const
{
    switch(role) {
    case CodeRole:
        return code();
    case OnAllDesktopsRole:
        return onAllDesktops();
    case OnAllActivitiesRole:
        return onAllActivities();
    case ClassClassRole:
        return classClass();
    case NameRole:
        return name();
    case IconRole:
        return icon();
    case DesktopRole:
        return desktop();
    case ActivitiesRole:
        return activities();
    default:
        return QVariant();
    }
}

#include "taskitem.moc"
