#ifndef ACTIVITIESENHANCEDMODEL_H
#define ACTIVITIESENHANCEDMODEL_H

#include "listmodel.h"
#include "activityitem.h"

class ActivitiesEnhancedModel : public ListModel
{
  Q_OBJECT

public:
  explicit ActivitiesEnhancedModel(QObject *parent = 0):
    ListModel(new ActivityItem, parent) {
  }

  Q_INVOKABLE QObject* workareas(const QString &id) const {
    ActivityItem *activity = static_cast<ActivityItem*>(find(id));
    if(activity) {
      return activity->workareas();
    }
    return 0;
  }
};

#endif
