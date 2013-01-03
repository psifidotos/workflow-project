#ifndef PLUGINSYNCACTIVITIESWORKAREAS_H
#define PLUGINSYNCACTIVITIESWORKAREAS_H

#include <QObject>

//This class suncs the number of desktops and workareas
//in order to be every time relevant. It takes account
//every time the number of workareas first.
//BE CAREFUL:You can not add a desktop outside of the plasmoid
//because there is not a relevant workarea
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
