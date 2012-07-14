#ifndef PTASKMANAGER_H
#define PTASKMANAGER_H

#include <QObject>

#include <taskmanager/taskmanager.h>
#include <KWindowSystem>
#include <KTempDir>


class PTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit PTaskManager(QObject *parent = 0);
    ~PTaskManager();

    Q_INVOKABLE void setOnDesktop(QString id, int desk);
    Q_INVOKABLE void setOnAllDesktops(QString id, bool b);
    Q_INVOKABLE void closeTask(QString id);
    Q_INVOKABLE void activateTask(QString id);
    Q_INVOKABLE void setCurrentDesktop(int desk);
    Q_INVOKABLE QString getDesktopName(int n);
    Q_INVOKABLE int getMaxDesktops();
    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QIcon &ic);

#ifdef Q_WS_X11
    Q_INVOKABLE void slotAddDesktop();
    Q_INVOKABLE void slotRemoveDesktop();
    Q_INVOKABLE void setOnlyOnActivity(QString, QString);
    Q_INVOKABLE void setOnAllActivities(QString);
    Q_INVOKABLE QPixmap windowPreview(QString window, int size);
    Q_INVOKABLE QPixmap windowScreenshot(QString win, int size);
    Q_INVOKABLE float windowScreenshotRatio(QString win);

    Q_INVOKABLE void setWindowPreview(QString win,int x, int y, int width, int height);
    Q_INVOKABLE void removeWindowPreview(QString win);

    Q_INVOKABLE void showWindowsPreviews();
    Q_INVOKABLE void hideWindowsPreviews();

    Q_INVOKABLE float getWindowRatio(QString win);
#endif

    void setMainWindowId(WId win);
    void setQMlObject(QObject *obj);

    void setTopXY(int,int);
    WId getMainWindowId();

signals:
    void taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant);
    void taskRemovedIn(QVariant);
    void taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant);
    void currentDesktopChanged(QVariant);
    void numberOfDesktopsChanged(QVariant);


public slots:
 //void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void taskAdded(::TaskManager::Task *);
  void taskRemoved(::TaskManager::Task *);
  void taskUpdated(::TaskManager::TaskChanges changes);
  void desktopChanged(int);
  void changeNumberOfDesktops(int);




private:
    TaskManager::TaskManager *taskMainM;
    KWindowSystem *kwinSystem;
    
    QObject *qmlTaskEngine;

    KTempDir *m_tempdir;

    QList<QRect> previewsRects;
    QList<WId> previewsIds;

    WId m_mainWindowId;

    int topX;
    int topY;

    int indexOfPreview(WId window);
    void hideDashboard();

};

#endif // PTASKMANAGER_H
