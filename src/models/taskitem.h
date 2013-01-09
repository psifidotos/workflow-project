#ifndef TASKITEM_H
#define TASKITEM_H

#include <QVariant>
#include <QHash>
#include <QByteArray>
#include <QStringList>

#include "listitem.h"

class TaskItem : public ListItem
{
  Q_OBJECT

public:

  enum Roles {
    CodeRole = Qt::UserRole+1,
    OnAllDesktopsRole,
    OnAllActivitiesRole,
    ClassClassRole,
    NameRole,
    IconRole,
    DesktopRole,
    ActivitiesRole
  };

  TaskItem(QObject *parent = 0): ListItem(parent) {}
  explicit TaskItem(const QString &code,
                    const bool &onAllDesktops,
                    const bool &onAllActivities,
                    const QString &classClass,
                    const QString &name,
                    const QString &icon,
                    const int &desktop,
                    const QStringList &activities,
                    QObject *parent = 0);
  ~TaskItem();

  QVariant data(int role) const;
  QHash<int, QByteArray> roleNames() const;

  inline QString id() const { return m_code; }
  inline QString code() const { return m_code; }
  inline bool onAllDesktops() const { return m_onAllDesktops; }
  inline bool onAllActivities() const { return m_onAllActivities; }
  inline QString classClass() const { return m_classClass; }
  inline QString name() const { return m_name; }
  inline QString icon() const { return m_icon; }
  inline int desktop() const { return m_desktop; }
  inline QStringList activities() const { return m_activities; }

  void setProperty(QString role,QVariant value);
  void setCode(QString);
  void setOnAllDesktops(bool);
  void setOnAllActivities(bool);
  void setClassClass(QString);
  void setName(QString);
  void setIcon(QString);
  void setDesktop(int);
  void setActivities(QStringList);

private:
  QString m_code;
  bool m_onAllDesktops;
  bool m_onAllActivities;
  QString m_classClass;
  QString m_name;
  QString m_icon;
  int m_desktop;
  QStringList m_activities;
};

#endif
