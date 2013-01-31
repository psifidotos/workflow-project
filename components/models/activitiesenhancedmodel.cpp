#include "activitiesenhancedmodel.h"
#include <QtAlgorithms>
#include <QDebug>

QObject* ActivitiesEnhancedModel::workareas(const QString &id) const
{
  ActivityItem *activity = static_cast<ActivityItem*>(find(id));
  if(activity) {
    return activity->workareas();
  }
  return 0;
}


bool ActivitiesEnhancedModel::activityLessThan(ListItem *a, ListItem *b )
{
    ActivityItem *actA = static_cast<ActivityItem *>(a);
    ActivityItem *actB = static_cast<ActivityItem *>(b);
    return (actA->order() < actB->order());
   // return true;
}


void ActivitiesEnhancedModel::sortModel()
{
    emit layoutAboutToBeChanged();
    qSort( m_list.begin(), m_list.end(), ActivitiesEnhancedModel::activityLessThan );
    emit layoutChanged();
}

#include "activitiesenhancedmodel.moc"
