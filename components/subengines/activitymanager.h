#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H

#include <KActivities/Controller>

class PluginChangeWorkarea;
class ActivitiesEnhancedModel;

namespace KActivities
{
class Controller;
}

namespace Plasma {
class Containment;
class Corona;
}

class ActivityManager : public QObject
{
    Q_OBJECT
public:
    explicit ActivityManager(ActivitiesEnhancedModel *,QObject *parent = 0);
    ~ActivityManager();

    //  Q_INVOKABLE void createActivityFromScript(const QString &script, const QString &name, const QString &icon, const QStringList &startupApps);
    //  Q_INVOKABLE void downloadActivityScripts();

    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QString &ic);
    Q_INVOKABLE void add(QString name);

    Q_INVOKABLE void setCurrent(QString id);
    Q_INVOKABLE void stop(QString id);
    Q_INVOKABLE void start(QString id);
    Q_INVOKABLE void setName(QString id, QString name);
    Q_INVOKABLE void remove(QString id);
    Q_INVOKABLE void setIcon(QString id, QString name);
    Q_INVOKABLE QString chooseIcon(QString id);
    Q_INVOKABLE QString chooseIconInKWin(QString);
    Q_INVOKABLE QString name(QString id);
    Q_INVOKABLE QString cstate(QString id);

    Q_INVOKABLE void moveActivityInModel(QString activity, int position);
    Q_INVOKABLE void setCurrentInModel(QString activity, QString status);

    //    Q_INVOKABLE int askForDelete(QString activityName);

    QString getCurrentActivityName();
    QString getCurrentActivityIcon();

protected:
    void init();

signals:
    void activityAdded(QString);
    void activityRemoved(QString);     

public slots:
    void activityAddedSlot(QString id);
    void activityRemovedSlot(QString id);
    void activityUpdatedSlot();
    void activityStateChangedSlot();

    //SIGNALS FROM THE PLUGINS
    void changeWorkareaEnded(QString, int);

    Q_INVOKABLE void setCurrentActivityAndDesktop(QString, int);
private:

    KActivities::Controller *m_activitiesCtrl;

    PluginChangeWorkarea *m_plChangeWorkarea;

    bool m_firstTime;

    ActivitiesEnhancedModel *m_actModel;

    QString stateToString(int);
};

#endif // ACTIVITYMANAGER_H
