#include "qmlsortfilterproxymodel.h"

#include <QDebug>
#include <QSortFilterProxyModel>

#include "listmodel.h"

QmlSortFilterProxyModel::QmlSortFilterProxyModel(QObject *parent):
    QSortFilterProxyModel(parent),
    m_count(0)
{
    connect(this, SIGNAL(rowsInserted(QModelIndex, int, int)), this, SLOT(rowsInsertedSlot(QModelIndex,int,int)));
    connect(this, SIGNAL(rowsRemoved(QModelIndex, int, int)), this, SLOT(rowsRemovedSlot(QModelIndex,int,int)));
//    connect(this, SIGNAL(dataChanged(QModelIndex,QModelIndex)), this, SLOT(dataChangedSlot(QModelIndex,QModelIndex)));
    setDynamicSortFilter(true);
}


void QmlSortFilterProxyModel::setSourceMainModel(QObject *model)
{
    ListModel *listModel = static_cast<ListModel *>(model);
    if(listModel != sourceModel()){
        setSourceModel(listModel);

        emit sourceMainModelChanged(listModel);
    }
}


int QmlSortFilterProxyModel::getCount()
{
    return m_count;
}

void QmlSortFilterProxyModel::setCount(int count)
{
    if(m_count != count){
        m_count = count;
        emit countChanged(m_count);
    }
}

void QmlSortFilterProxyModel::rowsInsertedSlot ( const QModelIndex & parent, int start, int end )
{
    Q_UNUSED(parent);
    Q_UNUSED(start);
    Q_UNUSED(end);
    setCount(rowCount());
}

void QmlSortFilterProxyModel::rowsRemovedSlot ( const QModelIndex & parent, int start, int end )
{
    Q_UNUSED(parent);
    Q_UNUSED(start);
    Q_UNUSED(end);
    setCount(rowCount());
}
/*
void QmlSortFilterProxyModel::dataChangedSlot ( const QModelIndex & topLeft, const QModelIndex & bottomRight )
{
    Q_UNUSED(topLeft);
    Q_UNUSED(bottomRight);
    //emit countChanged(rowCount());
}*/


#include "qmlsortfilterproxymodel.moc"
