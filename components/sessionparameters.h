#ifndef SESSIONPARAMETERS_H
#define SESSIONPARAMETERS_H

#include <QObject>
#include <KActivities/Controller>

/* A simple wrapper around Environment's parameters */
class SessionParameters : public QObject
{
    Q_OBJECT
public:

    Q_PROPERTY(QString currentActivity READ currentActivity WRITE setCurrentActivity NOTIFY currentActivityChanged)

    explicit SessionParameters(QObject *parent = 0);
    ~SessionParameters();

    QString currentActivity();

signals:
    void currentActivityChanged(QString);

public slots:
    void setCurrentActivity(QString);

private:
    KActivities::Controller *m_controller;

    QString m_currentActivity;

    void initConnections();
};

#endif /* SESSIONPARAMETERS_H */
