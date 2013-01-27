#ifndef QMLSORTFILTERPROXYMODEL_H
#define QMLSORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

class QmlSortFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QObject *sourceMainModel READ sourceMainModel WRITE setSourceMainModel NOTIFY sourceMainModelChanged)

    Q_PROPERTY(int count READ getCount NOTIFY countChanged)

public:
    explicit QmlSortFilterProxyModel(QObject *parent = 0);

    inline QObject *sourceMainModel(){return sourceModel();}
    void setSourceMainModel(QObject *model);

    int getCount();

protected:
    void setCount(int count);

private slots:
    void rowsInsertedSlot ( const QModelIndex & parent, int start, int end );
    void rowsRemovedSlot ( const QModelIndex & parent, int start, int end );
    void dataChangedSlot ( const QModelIndex & topLeft, const QModelIndex & bottomRight );

signals:
    void sourceMainModelChanged(QObject *);
    void countChanged(int);

private:
    int m_count;
};

#endif
