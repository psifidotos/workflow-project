#include "activityitem.h"
#include "listitem.h"

ActivityItem::ActivityItem(const QString &code, const QString &name,
                           const QString &icon, const QString &cstate, QObject *parent) :
  ListItem(parent),
  m_code(code),
  m_name(name),
  m_icon(icon),
  m_cstate(cstate)
{
}

/*
void ActivityItem::setPrice(qreal price)
{
  if(m_price != price) {
    m_price = price;
    emit dataChanged();
  }
}*/

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

QHash<int, QByteArray> ActivityItem::roleNames() const
{
  QHash<int, QByteArray> names;
  names[CodeRole] = "code";
  names[NameRole] = "Name";
  names[IconRole] = "Icon";
  names[CStateRole] = "CState";
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
  default:
    return QVariant();
  }
}

#include "activityitem.moc"


