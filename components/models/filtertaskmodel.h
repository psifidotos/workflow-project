#ifndef FILTERTASKMODEL_H
#define FILTERTASKMODEL_H

#include "qmlsortfilterproxymodel.h"

class FilterTaskModel : public QmlSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QString activity READ activity WRITE setActivity NOTIFY activityChanged)
    Q_PROPERTY(int desktop READ desktop WRITE setDesktop NOTIFY desktopChanged)
    Q_PROPERTY(bool everywhereState READ everywhereState WRITE setEverywhereState NOTIFY everywhereStateChanged)
    Q_PROPERTY(bool clear READ getClear WRITE setClear NOTIFY clearChanged)

public:
    explicit FilterTaskModel(QObject *parent = 0);

    inline QString activity(){return m_activity;}
    void setActivity(QString);

    inline int desktop(){return m_desktop;}
    void setDesktop(int desktop);

    inline bool everywhereState(){return m_everywhereState;}
    void setEverywhereState(bool state);

    inline bool getClear(){return m_clear;}
    void setClear(bool clear);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const;

signals:
    void activityChanged(QString);
    void desktopChanged(int);
    void everywhereStateChanged(bool);
    void clearChanged(bool);

private:
    QString m_activity;
    int m_desktop;
    bool m_everywhereState;
    bool m_clear;
};

#endif
