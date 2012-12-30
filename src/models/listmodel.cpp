/*
 * Author: Christophe Dumez <dchris@gmail.com>
 * License: Public domain (No attribution required)
 * Website: http://cdumez.blogspot.com/
 * Version: 1.0
 */

#include "listmodel.h"

#include <QAbstractListModel>


ListModel::ListModel(ListItem* prototype, QObject *parent) :
    QAbstractListModel(parent), m_prototype(prototype), m_count(0)
{
  setRoleNames(m_prototype->roleNames());
}

ListModel::~ListModel() {
  delete m_prototype;
  clear();
}

int ListModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return m_list.size();
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
  if(index.row() < 0 || index.row() >= m_list.size())
    return QVariant();
  return m_list.at(index.row())->data(role);
}



void ListModel::appendRow(ListItem *item)
{
  appendRows(QList<ListItem*>() << item);
}

void ListModel::appendRows(const QList<ListItem *> &items)
{
  beginInsertRows(QModelIndex(), rowCount(), rowCount()+items.size()-1);
  foreach(ListItem *item, items) {
    connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
    m_list.append(item);
  }
  endInsertRows();
  emit countChanged(getCount());
}

void ListModel::insertRow(int row, ListItem *item)
{
  beginInsertRows(QModelIndex(), row, row);
  connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
  m_list.insert(row, item);
  endInsertRows();
  emit countChanged(getCount());
}

void ListModel::handleItemChange()
{
  ListItem* item = static_cast<ListItem*>(sender());
  QModelIndex index = indexFromItem(item);
  if(index.isValid())
    emit dataChanged(index, index);
}

ListItem * ListModel::find(const QString &id) const
{
  foreach(ListItem* item, m_list) {
    if(item->id() == id) return item;
  }
  return 0;
}

QModelIndex ListModel::indexFromItem(const ListItem *item) const
{
  Q_ASSERT(item);
  for(int row=0; row<m_list.size(); ++row) {
    if(m_list.at(row) == item) return index(row);
  }
  return QModelIndex();
}

void ListModel::clear()
{
  qDeleteAll(m_list);
  m_list.clear();
  emit countChanged(getCount());
}

bool ListModel::removeRow(int row, const QModelIndex &parent)
{
  Q_UNUSED(parent);
  if(row < 0 || row >= m_list.size()) return false;
  beginRemoveRows(QModelIndex(), row, row);
  delete m_list.takeAt(row);
  endRemoveRows();
  emit countChanged(getCount());
  return true;
}

bool ListModel::removeRows(int row, int count, const QModelIndex &parent)
{
  Q_UNUSED(parent);
  if(row < 0 || (row+count) >= m_list.size()) return false;
  beginRemoveRows(QModelIndex(), row, row+count-1);
  for(int i=0; i<count; ++i) {
    delete m_list.takeAt(row);
  }
  endRemoveRows();
  return true;
}

ListItem * ListModel::takeRow(int row)
{
  beginRemoveRows(QModelIndex(), row, row);
  ListItem* item = m_list.takeAt(row);
  endRemoveRows();
  return item;
}

QVariant ListModel::get(int row)
{
    ListItem * item = m_list.at(row);
    QMap<QString, QVariant> itemData;
    QHashIterator<int, QByteArray> hashItr(item->roleNames());
    while(hashItr.hasNext()){
        hashItr.next();
        itemData.insert(hashItr.value(),item->data(hashItr.key()).toString());
    }
    // Edit:
    // My C++ is sometimes a bit rusty, I was deleting item...
    // DO NOT delete item... otherwise you remove the item from the ListModel
    // delete item;
    return QVariant(itemData);
}


void ListModel::remove(int row)
{
    removeRow(row, QModelIndex());
}

void ListModel::setProperty(int row, QString role, QVariant value)
{
    ListItem *item = (ListItem *)m_list.at(row);
    item->setProperty(role,value);
}


#include "listmodel.moc"
