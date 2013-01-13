#ifndef PREVIEWSMANAGER_H
#define PREVIEWSMANAGER_H

#include <QObject>
#include <QRect>

#include <taskmanager/taskmanager.h>

class PreviewsManager : public QObject
{
    Q_OBJECT
public:
    explicit PreviewsManager(QObject *parent = 0);
    ~PreviewsManager();

#ifdef Q_WS_X11
    Q_INVOKABLE void setWindowPreview(QString win,int x, int y, int width, int height);


    Q_INVOKABLE void showWindowsPreviews();
    Q_INVOKABLE void hideWindowsPreviews();

    Q_INVOKABLE float getWindowRatio(QString win);
    Q_INVOKABLE bool mainWindowIdisSet();
#endif

    WId getMainWindowId();

signals:
    void updatePopWindowWId();

protected:
    void init();

public slots:
    void setMainWindowId(QString);
    void setTopXY(int,int);
    Q_INVOKABLE void removeWindowPreview(QString win);

private:
    QList<QRect> previewsRects;
    QList<WId> previewsIds;

    WId m_mainWindowId;

    int topX;
    int topY;

    bool clearedPreviewsList;

    int indexOfPreview(WId window);

    void removeTaskFromPreviewsLists(WId window);
};

#endif // PreviewsManager_H
