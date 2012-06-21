#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H

#include <QObject>

#include <Plasma/DataEngine>


class ActivityManager : public QObject
{
    Q_OBJECT
public:
    explicit ActivityManager(QObject *parent = 0);
    ~ActivityManager();

//  Q_INVOKABLE void cloneCurrentActivity();
//  Q_INVOKABLE void createActivity(const QString &pluginName);
//  Q_INVOKABLE void createActivityFromScript(const QString &script, const QString &name, const QString &icon, const QStringList &startupApps);
//  Q_INVOKABLE void downloadActivityScripts();

    Q_INVOKABLE QString getWallpaper(QString source) const;
    Q_INVOKABLE QString chooseIcon(QString) const;
    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QString &ic);
    Q_INVOKABLE void add(QString id, QString name);
    Q_INVOKABLE void clone(QString id, QString name);
    Q_INVOKABLE void setCurrent(QString id);
    Q_INVOKABLE void stop(QString id);
    Q_INVOKABLE void start(QString id);
    Q_INVOKABLE void setName(QString id, QString name);
    Q_INVOKABLE void remove(QString id);
    Q_INVOKABLE int askForDelete(QString activityName);

    void setQMlObject(QObject *obj,Plasma::DataEngine *engin);

signals:
    void activityAddedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void activityUpdatedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);


public slots:
  void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void activityAdded(QString id);
  void activityRemoved(QString id);

private:
    void setIcon(QString id, QString name) const;


    QObject *qmlActEngine;
    Plasma::DataEngine *plasmaActEngine;

};

#endif // ACTIVITYMANAGER_H
