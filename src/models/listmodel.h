/*
 * Author: Christophe Dumez <dchris@gmail.com>
 * License: Public domain (No attribution required)
 * Website: http://cdumez.blogspot.com/
 * Version: 1.0
 */

#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>
#include <QModelIndex>

#include "listitem.h"

class ListModel : public QAbstractListModel
{
  Q_OBJECT
  Q_PROPERTY( int count READ getCount() NOTIFY countChanged())

public:
  explicit ListModel(ListItem* prototype, QObject* parent = 0);
  ~ListModel();
  int rowCount(const QModelIndex &parent = QModelIndex()) const;
  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  void appendRow(ListItem* item);
  void appendRows(const QList<ListItem*> &items);
  void insertRow(int row, ListItem* item);
  bool removeRow(int row, const QModelIndex &parent = QModelIndex());
  bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
  ListItem* at(int row);
  ListItem* takeRow(int row);
  ListItem* find(const QString &id) const;
  QModelIndex indexFromItem( const ListItem* item) const;
  void clear();

  int getCount() { this->m_count = this->rowCount(); return m_count; }

  Q_INVOKABLE QVariant get(int row);
  Q_INVOKABLE void remove(int row);
  Q_INVOKABLE void setProperty(int row, QString role, QVariant value);

signals:
  void countChanged(int);

private slots:
  void handleItemChange();

private:
  ListItem* m_prototype;
  QList<ListItem*> m_list;

  int m_count;
};

#endif // LISTMODEL_H
