#include "filtertaskmodel.h"

#include "taskitem.h"

#include <QDebug>

FilterTaskModel::FilterTaskModel(QObject *parent):
    QmlSortFilterProxyModel(parent),
    m_activity(""),
    m_desktop(0),
    m_everywhereState(false)
{
}

bool FilterTaskModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

    QStringList activities = sourceModel()->data(index, TaskItem::ActivitiesRole).toStringList();
    int desktop = sourceModel()->data(index, TaskItem::DesktopRole).toInt();
    bool onAllActivities = sourceModel()->data(index, TaskItem::OnAllActivitiesRole).toBool();
    bool onAllDesktops = sourceModel()->data(index, TaskItem::OnAllDesktopsRole).toBool();

    bool result = ( ( ((activities.size() != 0) && (activities[0] == m_activity)&&
                      ((desktop == m_desktop) || onAllDesktops) ) ||
                    ((desktop == m_desktop) && onAllActivities) ||
                    (m_everywhereState && onAllActivities && onAllDesktops)
                    ) && (!m_clear) );

    return result;
}


void FilterTaskModel::setActivity(QString activity)
{
    if(m_activity != activity){
        m_activity = activity;
        emit activityChanged(activity);
        invalidate();
        setCount(rowCount());
    }
}


void FilterTaskModel::setDesktop(int desktop)
{
    if(m_desktop != desktop){
        m_desktop = desktop;
        emit desktopChanged(m_desktop);
        invalidate();
        setCount(rowCount());
    }
}


void FilterTaskModel::setEverywhereState(bool state)
{
    if(m_everywhereState != state){
        m_everywhereState = state;
        emit everywhereStateChanged(state);
        invalidate();
        setCount(rowCount());
    }
}

void FilterTaskModel::setClear(bool clear)
{
    if(m_clear != clear){
        m_clear = clear;
        emit clearChanged(m_clear);
        invalidate();
        setCount(rowCount());
    }
}

#include "filtertaskmodel.moc"
