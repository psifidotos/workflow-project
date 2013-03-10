#ifndef MECHANISMUPDATEWORKAREASNAME_H
#define MECHANISMUPDATEWORKAREASNAME_H

#include <QObject>

//This Plugin class fixes a bug when adding a workarea in a greater position
//than the number of desktops. More spesific updates correctly the workarea's
//name
class MechanismUpdateWorkareasName : public QObject
{
    Q_OBJECT
public:
    explicit MechanismUpdateWorkareasName(QObject *);
    ~MechanismUpdateWorkareasName();

//    void checkFlag(int);

signals:
    void updateWorkareasName(int);

protected:
    void init();

private slots:
    void numberOfDesktopsChangedSlot(int);

private:
    int m_desktops;
    bool m_awaitingName;
};

#endif
