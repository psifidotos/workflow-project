#ifndef ACTIVITYITEM_H
#define ACTIVITYITEM_H


#include <QVariant>
#include <QHash>
#include <QByteArray>
#include <QStringList>

#include "listitem.h"

class ActivityItem : public ListItem
{
  Q_OBJECT

public:
  enum Roles {
    CodeRole = Qt::UserRole+1,
    NameRole,
    IconRole,
    CStateRole,
    BackgroundRole,
    WorkareasRole
  };

  ActivityItem(QObject *parent = 0): ListItem(parent) {}
  explicit ActivityItem(const QString &code, const QString &name,
                        const QString &icon, const QString &cstate,
                        const QString &background,
                        QObject *parent = 0);
  ~ActivityItem(){}

  QVariant data(int role) const;
  QHash<int, QByteArray> roleNames() const;

  inline QString id() const { return m_code; }
  inline QString code() const { return m_code; }
  inline QString name() const { return m_name; }
  inline QString icon() const { return m_icon; }
  inline QString cstate() const { return m_cstate; }
  inline QString background() const { return m_background; }
  inline QStringList workareas() const { return m_workareas; }

  void setProperty(QString role,QVariant value);
  void setCode(QString);
  void setName(QString);
  void setIcon(QString);
  void setCState(QString);
  void setBackground(QString);

  Q_INVOKABLE void addWorkarea(QString);
  Q_INVOKABLE void removeWorkarea(int);
  Q_INVOKABLE void renameWorkarea(int, QString);

private:
  QString m_code;
  QString m_name;
  QString m_icon;
  QString m_cstate;
  QString m_background;
  QStringList m_workareas;
};

#endif
