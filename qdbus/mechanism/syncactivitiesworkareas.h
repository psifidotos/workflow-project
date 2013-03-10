#ifndef SYNCACTIVITIESWORKAREAS_H
#define SYNCACTIVITIESWORKAREAS_H

#include <QObject>

//This class suncs the number of desktops and workareas
//in order to be every time relevant. It takes account
//every time the number of workareas first.
//BE CAREFUL:You can not add a desktop outside of the plasmoid
//because there is not a relevant workarea
class SyncActivitiesWorkareas : public QObject
{
    Q_OBJECT
public:
    explicit SyncActivitiesWorkareas(QObject *);
    ~SyncActivitiesWorkareas();

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
