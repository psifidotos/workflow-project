#include "workareaitem.h"
#include "listitem.h"

WorkareaItem::WorkareaItem(const QString &code, const QString &title,
                           const bool &enabled, QObject *parent) :
  ListItem(parent),
  m_code(code),
  m_title(title),
  m_enabled(enabled)
{
}


void WorkareaItem::setProperty(QString role,QVariant value)
{
    QHash<int, QByteArray> names = roleNames();

    if(role == names[CodeRole])
        setCode(value.toString());
    else if(role == names[TitleRole])
        setTitle(value.toString());
    else if(role == names[EnabledRole])
        setEnabled(value.toBool());
}

void WorkareaItem::setCode(QString code)
{
    if(m_code != code){
        m_code = code;
        emit dataChanged();
    }
}
void WorkareaItem::setTitle(QString title)
{
    if(m_title != title){
        m_title = title;
        emit dataChanged();
    }
}

void WorkareaItem::setEnabled(bool enabled)
{
    if(m_enabled != enabled){
        m_enabled = enabled;
        emit dataChanged();
    }
}


QHash<int, QByteArray> WorkareaItem::roleNames() const
{
  QHash<int, QByteArray> names;
  names[CodeRole] = "code";
  names[TitleRole] = "title";
  names[EnabledRole] = "enabled";
  return names;
}

QVariant WorkareaItem::data(int role) const
{
  switch(role) {
  case CodeRole:
    return code();
  case TitleRole:
    return title();
  case EnabledRole:
    return enabled();
  default:
    return QVariant();
  }
}

#include "workareaitem.moc"


