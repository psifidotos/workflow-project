#ifndef PLUGINSYNCACTIVITIESWORKAREAS_H
#define PLUGINSYNCACTIVITIESWORKAREAS_H

#include <QObject>


class PluginSyncActivitiesWorkareas : public QObject
{
    Q_OBJECT
public:
    explicit PluginSyncActivitiesWorkareas(QObject *);
    ~PluginSyncActivitiesWorkareas();

    void execute();

protected:
    void init();

public slots:
    void maxWorkareasUpdated(int);

private slots:
    void numberOfDesktopsChangedSlot(int);

private:
    int m_desktops;
    int m_workareas;

    void addDesktop();
    void removeDesktop();
};

#endif
