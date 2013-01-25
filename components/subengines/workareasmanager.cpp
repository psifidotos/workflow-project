#include "workareasmanager.h"

#include <QDebug>

#include <Plasma/DataEngineManager>
#include <Plasma/Service>
#include <Plasma/ServiceJob>

#include "../models/activitiesenhancedmodel.h"
#include "../models/workareaitem.h"
#include "../models/activityitem.h"
#include "../models/listmodel.h"

#include <taskmanager/task.h>

WorkareasManager::WorkareasManager(ActivitiesEnhancedModel *model,QObject *parent) :
    QObject(parent),
    m_maxWorkareas(0),
    m_actModel(model),
    m_dataEngine(0)
{
    init();
}

WorkareasManager::~WorkareasManager()
{
    Plasma::DataEngineManager::self()->unloadEngine("workareas");
}

void WorkareasManager::init()
{
    m_dataEngine = Plasma::DataEngineManager::self()->loadEngine("workareas");

    foreach (const QString source, m_dataEngine->sources())
      activityAddedSlot(source);

    // activity addition and removal
    connect(m_dataEngine, SIGNAL(sourceAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_dataEngine, SIGNAL(sourceRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));
}

QString WorkareasManager::name(QString id, int desktop)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model){
        WorkareaItem *workarea = static_cast<WorkareaItem *>(model->at(desktop-1));
        return workarea->title();
    }

    return "";
}

int WorkareasManager::numberOfWorkareas(QString actId)
{
    ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(actId));

    if (workareasModel)
        return workareasModel->getCount();

    return 0;
}

void WorkareasManager::activityAddedSlot(QString id)
{
    if(id == "Settings")
        return;

    m_dataEngine->connectSource(id, this);
}

void WorkareasManager::activityRemovedSlot(QString id)
{
    Q_UNUSED(id);
    //The removal of activity in the model is done from the activitymanager
}

void WorkareasManager::addWorkareaInModel(QString id, QString name)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model)
        model->appendRow(new WorkareaItem(name,name,true,model));
}

void WorkareasManager::removeWorkareaInModel(QString id, int desktop)
{
    ListModel *model = static_cast<ListModel *>(m_actModel->workareas(id));
    if(model)
        model->removeRow(desktop-1);
}

void WorkareasManager::dataUpdated(QString source, Plasma::DataEngine::Data data) {
  ListModel *workareasModel = static_cast<ListModel *>(m_actModel->workareas(source));
  ActivityItem *activity = static_cast<ActivityItem *>(m_actModel->find(source));

  if(workareasModel && activity ){
      //update background
      activity->setBackground(data["Background"].toString());

      //update workareas
      int prevSize = workareasModel->getCount();

      QStringList newWorkareas = data["Workareas"].toStringList();
      int newSize = newWorkareas.size();

      for(int i=0; i<newSize; ++i )
      {
          WorkareaItem *workarea = static_cast<WorkareaItem *>(workareasModel->at(i));

          if (i<prevSize)
              workarea->setTitle(newWorkareas.at(i));
          else
              addWorkareaInModel(source, newWorkareas.at(i));
      }

      if(prevSize > newSize)
          for(int j=newSize; j<prevSize; ++j )
              removeWorkareaInModel(source, j+1);
      //////
  }
}

void WorkareasManager::maxWorkareasChangedSlot(int size)
{
    if(m_maxWorkareas != size){
        m_maxWorkareas = size;
        emit maxWorkareasChanged(m_maxWorkareas);
    }
}

void WorkareasManager::addWorkArea(QString id, QString name)
{
    Plasma::Service *service = m_dataEngine->serviceForSource(id);
    KConfigGroup op = service->operationDescription("addWorkarea");
    op.writeEntry("Name", name);
    Plasma::ServiceJob *job = service->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void WorkareasManager::renameWorkarea(QString id, int desktop, QString name)
{
    Plasma::Service *service = m_dataEngine->serviceForSource(id);
    KConfigGroup op = service->operationDescription("renameWorkarea");
    op.writeEntry("Desktop", desktop);
    op.writeEntry("Name", name);
    Plasma::ServiceJob *job = service->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void WorkareasManager::removeWorkarea(QString id, int desktop)
{
    Plasma::Service *service = m_dataEngine->serviceForSource(id);
    KConfigGroup op = service->operationDescription("removeWorkarea");
    op.writeEntry("Desktop", desktop);
    Plasma::ServiceJob *job = service->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void WorkareasManager::cloneWorkareas(QString from, QString to)
{
    Plasma::Service *service = m_dataEngine->serviceForSource(from);
    KConfigGroup op = service->operationDescription("cloneWorkareas");
    op.writeEntry("Activity", to);
    Plasma::ServiceJob *job = service->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

#include "workareasmanager.moc"
