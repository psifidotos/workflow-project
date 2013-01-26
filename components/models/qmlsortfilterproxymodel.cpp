#include "qmlsortfilterproxymodel.h"

#include <QDebug>
#include <QSortFilterProxyModel>

#include "listmodel.h"

QmlSortFilterProxyModel::QmlSortFilterProxyModel(QObject *parent):
    QSortFilterProxyModel(parent)
{
    connect(this, SIGNAL(rowsInserted(QModelIndex, int, int)), this, SLOT(rowsInsertedSlot(QModelIndex,int,int)));
    connect(this, SIGNAL(rowsRemoved(QModelIndex, int, int)), this, SLOT(rowsRemovedSlot(QModelIndex,int,int)));
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
    return rowCount();
}

void QmlSortFilterProxyModel::rowsInsertedSlot ( const QModelIndex & parent, int start, int end )
{
    Q_UNUSED(parent);
    Q_UNUSED(start);
    Q_UNUSED(end);
    emit countChanged(rowCount());
}

void QmlSortFilterProxyModel::rowsRemovedSlot ( const QModelIndex & parent, int start, int end )
{
    Q_UNUSED(parent);
    Q_UNUSED(start);
    Q_UNUSED(end);
    emit countChanged(rowCount());
}


#include "qmlsortfilterproxymodel.moc"
