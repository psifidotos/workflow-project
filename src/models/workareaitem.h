#ifndef WORKAREAITEM_H
#define WORKAREAITEM_H


#include <QVariant>
#include <QHash>
#include <QByteArray>
#include <QStringList>

#include "listitem.h"

class WorkareaItem : public ListItem
{
  Q_OBJECT

public:
  enum Roles {
    CodeRole = Qt::UserRole+1,
    TitleRole,
    EnabledRole
  };

  WorkareaItem(QObject *parent = 0): ListItem(parent) {}
  explicit WorkareaItem(const QString &code, const QString &title,
                        const bool &enabled, QObject *parent = 0);
  ~WorkareaItem(){}

  QVariant data(int role) const;
  QHash<int, QByteArray> roleNames() const;

  inline QString id() const { return m_code; }
  inline QString code() const { return m_code; }
  inline QString title() const { return m_title; }
  inline bool enabled() const { return m_enabled; }

  void setProperty(QString role,QVariant value);
  void setCode(QString);
  void setTitle(QString);
  void setEnabled(bool);

  WorkareaItem *copy(QObject *parent);

private:
  QString m_code;
  QString m_title;
  bool m_enabled;

};

#endif
