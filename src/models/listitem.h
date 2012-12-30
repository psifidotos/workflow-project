#ifndef LISTITEM_H
#define LISTITEM_H

#include <QObject>
#include <QHash>
#include <QByteArray>


class ListItem: public QObject {
  Q_OBJECT

public:
  ListItem(QObject* parent = 0) : QObject(parent) {}
  virtual ~ListItem() {}
  virtual QString id() const = 0;
  virtual QVariant data(int role) const = 0;
  virtual QHash<int, QByteArray> roleNames() const = 0;
  virtual void setProperty(QString,QVariant) = 0;

signals:
  void dataChanged();
};

#endif
