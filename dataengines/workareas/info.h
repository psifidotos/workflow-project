#ifndef INFO_H
#define INFO_H

#include <QObject>
#include <QStringList>

namespace Workareas{

class Info : public QObject
{
    Q_OBJECT
public:
    explicit Info(QString id, QObject *parent = 0);
    ~Info();

    QString id() const;
    QString background() const;
    QString name(int position) const;
    int numberOfWorkareas() const;
    QStringList workareas() const;

signals:
    void workareaAdded(QString id, QString name);
    void workareaRemoved(QString id, int desktop);
    void workareaInfoUpdated(QString id);

protected:
    void addWorkArea(QString name);
    void renameWorkarea(int desktop, QString name);
    void removeWorkarea(int desktop);

    Workareas::Info *copy(QObject *parent = 0);
private:
    QString m_id;
    QString m_background;
    QStringList m_workareas;

    void setBackground(QString);

    friend class Store;
};

}
#endif // INFO_H
