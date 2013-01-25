#ifndef FILTERTASKMODEL_H
#define FILTERTASKMODEL_H

#include <QSortFilterProxyModel>

class FilterTaskModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QObject *sourceTaskModel READ sourceTaskModel WRITE setSourceTaskModel NOTIFY sourceTaskModelChanged)
    Q_PROPERTY(QString activity READ activity WRITE setActivity NOTIFY activityChanged)
    Q_PROPERTY(int desktop READ desktop WRITE setDesktop NOTIFY desktopChanged)
    Q_PROPERTY(bool everywhereState READ everywhereState WRITE setEverywhereState NOTIFY everywhereStateChanged)

    Q_PROPERTY(int count READ getCount NOTIFY countChanged)

public:
    explicit FilterTaskModel(QObject *parent = 0);

    inline QObject *sourceTaskModel(){return sourceModel();}
    void setSourceTaskModel(QObject *model);

    inline QString activity(){return m_activity;}
    void setActivity(QString);

    inline int desktop(){return m_desktop;}
    void setDesktop(int desktop);

    inline bool everywhereState(){return m_everywhereState;}
    void setEverywhereState(bool state);

    int getCount();
protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

signals:
    void sourceTaskModelChanged(QObject *);
    void activityChanged(QString);
    void desktopChanged(int);
    void everywhereStateChanged(bool);

    void countChanged(int);

private:
    QString m_activity;
    int m_desktop;
    bool m_everywhereState;
};

#endif
