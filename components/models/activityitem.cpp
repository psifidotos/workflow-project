#include "activityitem.h"
#include "listitem.h"
#include "workareaitem.h"

ActivityItem::ActivityItem(const QString &code, const QString &name,
                           const QString &icon, const QString &cstate,
                           const QStringList &backgrounds, QObject *parent) :
    ListItem(parent),
    m_code(code),
    m_name(name),
    m_icon(icon),
    m_cstate(cstate),
    m_backgrounds(backgrounds),
    m_order(0),
    m_workareas(0)
{
    m_workareas = new ListModel(new WorkareaItem,this);
}

ActivityItem::~ActivityItem()
{
    //It crashes the model for some reason when closing the application...
   // if(m_workareas){
        //      m_workareas->clear();
     //   delete m_workareas;
   // }
}

void ActivityItem::setProperty(QString role,QVariant value)
{
    QHash<int, QByteArray> names = roleNames();

    if(role == names[CodeRole])
        setCode(value.toString());
    else if(role == names[NameRole])
        setName(value.toString());
    else if(role == names[IconRole])
        setIcon(value.toString());
    else if(role == names[CStateRole])
        setCState(value.toString());
    else if(role == names[BackgroundRole])
        setBackgrounds(value.toStringList());
    else if(role == names[OrderRole])
        setOrder(value.toInt());
}

void ActivityItem::setCode(QString code)
{
    if(m_code != code){
        m_code = code;
        emit dataChanged();
    }
}
void ActivityItem::setName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }
}

void ActivityItem::setIcon(QString icon)
{
    if(m_icon != icon){
        m_icon = icon;
        emit dataChanged();
    }
}

void ActivityItem::setCState(QString cstate)
{
    if(m_cstate != cstate){
        m_cstate = cstate;
        emit dataChanged();
    }
}

void ActivityItem::setBackgrounds(QStringList backgrounds)
{
    if(m_backgrounds != backgrounds){
        m_backgrounds = backgrounds;
        emit dataChanged();
    }
}

void ActivityItem::setOrder(int order)
{
    if(m_order != order){
        m_order = order;
        emit dataChanged();
    }
}


QHash<int, QByteArray> ActivityItem::roleNames() const
{
    QHash<int, QByteArray> names;
    names[CodeRole] = "code";
    names[NameRole] = "Name";
    names[IconRole] = "Icon";
    names[CStateRole] = "CState";
    names[BackgroundRole] = "backgrounds";
    names[OrderRole] = "Order";
    return names;
}

QVariant ActivityItem::data(int role) const
{
    switch(role) {
    case CodeRole:
        return code();
    case NameRole:
        return name();
    case IconRole:
        return icon();
    case CStateRole:
        return cstate();
    case BackgroundRole:
        return backgrounds();
    case OrderRole:
        return order();
    default:
        return QVariant();
    }
}

#include "activityitem.moc"


