#ifndef ACTIVITYITEM_H
#define ACTIVITYITEM_H


#include <QVariant>
#include <QHash>
#include <QByteArray>
#include <QStringList>

#include "listitem.h"
#include "listmodel.h"

typedef ListModel WorkareasModel;

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
    OrderRole
  };

  ActivityItem(QObject *parent = 0): ListItem(parent) {}
  explicit ActivityItem(const QString &code, const QString &name,
                        const QString &icon, const QString &cstate,
                        const QString &background,
                        QObject *parent = 0);
  ~ActivityItem();

  bool operator<(const ActivityItem other) const {return order()<other.order();}

  QVariant data(int role) const;
  QHash<int, QByteArray> roleNames() const;

  inline QString id() const { return m_code; }
  inline QString code() const { return m_code; }
  inline QString name() const { return m_name; }
  inline QString icon() const { return m_icon; }
  inline QString cstate() const { return m_cstate; }
  inline QString background() const { return m_background; }
  inline int order() const { return m_order; }

  void setProperty(QString role,QVariant value);
  void setCode(QString);
  void setName(QString);
  void setIcon(QString);
  void setCState(QString);
  void setBackground(QString);
  void setOrder(int);

  WorkareasModel* workareas() const {
    return m_workareas;
  }

private:
  QString m_code;
  QString m_name;
  QString m_icon;
  QString m_cstate;
  QString m_background;
  int m_order;

  WorkareasModel *m_workareas;
};

#endif
