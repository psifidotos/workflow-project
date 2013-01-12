#include "previewsmanager.h"


#include <Plasma/WindowEffects>


PreviewsManager::PreviewsManager(QObject *parent) :
    QObject(parent),
    m_mainWindowId(0)
{
    clearedPreviewsList = true;

    init();
}


PreviewsManager::~PreviewsManager(){
    hideWindowsPreviews();
}

void PreviewsManager::init()
{

}

bool PreviewsManager::mainWindowIdisSet()
{
    return (m_mainWindowId>0);
}


WId PreviewsManager::getMainWindowId(){
    return m_mainWindowId;
}


void PreviewsManager::setTopXY(int x1,int y1)
{
    topX = x1;
    topY = y1;
}


void PreviewsManager::showWindowsPreviews()
{
    //    m_mainWindowId = RootWindow (QX11Info::display(), DefaultScreen (QX11Info::display()));
    //    qDebug() << m_mainWindowId;
    if (previewsIds.size()>0) {
        Plasma::WindowEffects::showWindowThumbnails(m_mainWindowId,previewsIds,previewsRects);
        clearedPreviewsList = false;
    }

    if ((previewsIds.size() == 0)&&(clearedPreviewsList == false)) {
        Plasma::WindowEffects::showWindowThumbnails(m_mainWindowId,previewsIds,previewsRects);
        clearedPreviewsList = true;
    }

}

void PreviewsManager::hideWindowsPreviews()
{
    previewsIds.clear();
    previewsRects.clear();
    showWindowsPreviews();
}

void PreviewsManager::setMainWindowId(WId win)
{
    if(m_mainWindowId != win){
        m_mainWindowId = win;
        showWindowsPreviews();
    }
}


float PreviewsManager::getWindowRatio(QString win)
{
    WId winId = win.toULong();

    QList<WId> wList;
    wList.append(winId);

    QList<QSize> sList;
    sList = Plasma::WindowEffects::windowSizes(wList);

    if (sList.size()>0){
        QSize wSz = sList.at(0);

        return (float)(wSz.rheight())/(float)(wSz.rwidth());
    }

    return 0;
}

int PreviewsManager::indexOfPreview(WId window)
{
    for (int i=0; i<previewsIds.size(); i++)
        if ( previewsIds.at(i) == window )
            return i;

    return -1;
}

void PreviewsManager::setWindowPreview(QString win,int x, int y, int width, int height)
{
    //int xEr = topX + 12;
    //int yEr = topY + 75;
    //  int xEr = topX+13;
    //  int yEr = topY+42;

    //QRect prSize(x+xEr,y+yEr,width,height);
    //   QRect prSize(x,y,width,height);
    QRect prSize(topX+x,topY+y,width,height);
    WId winId = win.toULong();

    int pos = indexOfPreview(winId);

    if (pos>-1){
        previewsRects[pos] = prSize;

        if(pos>0){
            previewsRects.move(pos,0);
            previewsIds.move(pos,0);
        }
    }
    else{
        previewsRects.insert(0, prSize);
        previewsIds.insert(0, winId);
        //   previewsRects << prSize;
        //  previewsIds << winId;
    }

    showWindowsPreviews();
}

void PreviewsManager::removeTaskFromPreviewsLists(WId window){
    int pos = indexOfPreview(window);

    if (pos>-1){
        previewsRects.removeAt(pos);
        previewsIds.removeAt(pos);
    }
}

void PreviewsManager::removeWindowPreview(QString win)
{
    WId winId = win.toULong();

    removeTaskFromPreviewsLists(winId);

    showWindowsPreviews();
}

#include "previewsmanager.moc"
