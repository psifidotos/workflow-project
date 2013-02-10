#ifndef PLASMOIDWRAPPER_H
#define PLASMOIDWRAPPER_H

#include <taskmanager/taskmanager.h>

namespace Plasma{
class PopupApplet;
}

/*
 *This class holds all the code from the Workfklow C++ Plasmoid
 *which can not be found with a clean qml plasmoid.
 *
 *That is the effectiveWinId
 */
class PlasmoidWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString version READ version NOTIFY versionChanged)
    Q_PROPERTY(bool isInPanel READ isInPanel NOTIFY isInPanelChanged)

public:
    explicit PlasmoidWrapper(QObject *parent = 0);
    ~PlasmoidWrapper();

    inline QString version(){return m_version;}
    inline bool isInPanel(){return m_isInPanel;}

    Q_INVOKABLE void setApplet(QObject *);

signals:
    void versionChanged(QString);
    void isInPanelChanged(bool);

    void updateMarginForPreviews(int x, int y);
    void updateWindowIDForPreviews(QString win);
    void workareaWasClicked();

public slots:
    Q_INVOKABLE void popupEventSlot(bool);
    Q_INVOKABLE void updatePopWindowWIdSlot();
    Q_INVOKABLE bool isPopupShowing();
    Q_INVOKABLE int currentWIdPosition();
    Q_INVOKABLE void nextWId();

private slots:
    void activeWindowChangedSlot(WId);
    void geometryChangedSlot();

private:
    bool m_isInPanel;
    bool m_findPopupWid;
    QString m_windowID;
    QString m_version;
    int m_wPosition;

    Plasma::PopupApplet *m_popupApplet;

    void setMainWindowId();
    void updateMainWId();
};

#endif // PlasmoidWrapper_H
