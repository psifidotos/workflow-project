#ifndef WORKAREAINFO_H
#define WORKAREAINFO_H

#include <QObject>
#include <QStringList>

class WorkareaInfo : public QObject
{
    Q_OBJECT
public:
    explicit WorkareaInfo(QString id, QObject *parent = 0);
    ~WorkareaInfo();

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

    WorkareaInfo *copy(QObject *parent = 0);
    bool cloneWorkareaInfo(WorkareaInfo *);
private:
    QString m_id;
    QString m_background;
    QStringList m_workareas;

    void setBackground(QString);

    friend class WorkareaManager;
};

#endif // WORKAREAINFO_H
