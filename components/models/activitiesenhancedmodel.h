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

  Q_INVOKABLE QObject* workareas(const QString &id) const;
  Q_INVOKABLE void sortModel();

  static bool activityLessThan(ListItem *a, ListItem *b );
};

#endif
