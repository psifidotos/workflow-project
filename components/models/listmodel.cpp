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

void ListModel::moveRow(int from, int to)
{
    if((from>=0) && (from<m_list.size()) &&
            (to>=0) && (to<m_list.size()) ){
        int newTo = to;

        //fix from http://stackoverflow.com/questions/12267620/qml-gridview-does-not-update-after-change-its-model-in-c
        if (from < to)
            newTo++;

//        if (to == (from+1))
  //          newTo++;

        beginMoveRows (QModelIndex(), from, from, QModelIndex(), newTo);

        m_list.move(from, to);
        //ListItem *tmp1 = takeRow(from);
   /*     if (from<to) {
            for (int i=from; i<to; i++) {
                ListItem *tmp2 = takeRow(i+1);
                insertRow(i, tmp2);
            }
        } else if (from>to) {
            for (int i=from; i>to; i--) {
                ListItem *tmp2 = takeRow(i-1);
                insertRow(i, tmp2);
            }
        }*/
        //insertRow(newTo, tmp1);
        //setItem(inx2,tmp1);

        endMoveRows();
    }
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

int ListModel::getIndexFor(const QString &id)
{
    for(int row=0; row<m_list.size(); row++) {
        if((m_list[row])->id() == id) return row;
    }

    return -1;
}

void ListModel::clear()
{
    removeRows(0,m_list.size(), QModelIndex());
    m_list.clear();
    emit countChanged(getCount());
}

bool ListModel::removeRow(int row, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    /*if(row < 0 || row > m_list.size()) return false;
    beginRemoveRows(QModelIndex(), row, row);
    delete m_list.takeAt(row);
    endRemoveRows();*/
    return removeRows(row, 1, parent);
    //emit countChanged(getCount());
    //return true;
}

bool ListModel::removeRows(int row, int count, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    if(row < 0 || (row+count) > m_list.size()) return false;
    beginRemoveRows(QModelIndex(), row, row+count-1);
    for(int i=0; i<count; ++i)
        delete m_list.takeAt(row);
    endRemoveRows();
    emit countChanged(getCount());
    return true;
}

ListItem * ListModel::takeRow(int row)
{
    beginRemoveRows(QModelIndex(), row, row);
    ListItem* item = m_list.takeAt(row);
    endRemoveRows();
    return item;
}

ListItem * ListModel::at(int row)
{
    ListItem* item = m_list.at(row);

    return item;
}


QVariant ListModel::get(int row)
{
    if(row>=0){
        ListItem * item = m_list.at(row);
        if (item){
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
    }
    return QVariant();
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
