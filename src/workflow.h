/***************************************************************************
 *   Copyright (C) 2011 by Martin Gräßlin <mgraesslin@kde.org>             *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

// Here we avoid loading the header multiple times
#ifndef WORKFLOW_HEADER
#define WORKFLOW_HEADER

// We need the Plasma Applet headers


#include <Plasma/Label>
#include <Plasma/PopupApplet>
#include <plasma/widgets/declarativewidget.h>
#include <Plasma/ExtenderItem>


#include <QGraphicsLinearLayout>

#include <KGlobal>
#include <KStandardDirs>
#include <KConfigGroup>

#include "activitymanager.h"
#include "ptaskmanager.h"
#include "ui_config.h"

class QDesktopWidget;

namespace Plasma {
    class ExtenderItem;
}

namespace Ui {
    class Config;
}

// Define our plasma Applet
class WorkFlow : public Plasma::PopupApplet
{
    Q_OBJECT

public:
    WorkFlow(QObject *parent, const QVariantList &args);
    ~WorkFlow();

    virtual void init();
    void initExtenderItem(Plasma::ExtenderItem *item);

    Q_INVOKABLE void loadConfigurationFiles();

    ///Properties
    Q_INVOKABLE void setZoomFactor(int zoom);
    Q_INVOKABLE void setShowWindows(bool show);
    Q_INVOKABLE void setLockActivities(bool lock);
    Q_INVOKABLE void setAnimations(int anim);
    Q_INVOKABLE void setHideOnClick(bool);
    Q_INVOKABLE void hidePopupDialog();

    Q_INVOKABLE void setWindowsPreviews(bool b);
    Q_INVOKABLE void setWindowsPreviewsOffsetX(int x);
    Q_INVOKABLE void setWindowsPreviewsOffsetY(int y);
    Q_INVOKABLE void setFontRelevance(bool fr);
    Q_INVOKABLE void setShowStoppedActivities(bool s);
    Q_INVOKABLE void setFirstRunLiveTour(bool f);
    Q_INVOKABLE void setFirstRunCalibrationPreviews(bool cal);

    Q_INVOKABLE void workAreaWasClicked();
    Q_INVOKABLE void showWidgetsExplorer();

    ///Workareas Storing/Accessing
    Q_INVOKABLE void loadWorkareas();
    Q_INVOKABLE void saveWorkareas();
    Q_INVOKABLE QStringList getWorkAreaNames(QString);
    Q_INVOKABLE void addWorkArea(QString id, QString name);
    Q_INVOKABLE void addEmptyActivity(QString id);
    Q_INVOKABLE void removeActivity(QString id);
    Q_INVOKABLE bool activityExists(QString id);
    Q_INVOKABLE void renameWorkarea(QString id, int desktop, QString name);
    Q_INVOKABLE void removeWorkarea(QString id, int desktop);

public slots:
    void geomChanged();
    void setMainWindowId();
    void statusChanged(Plasma::ItemStatus);
    void releasedVisualFocus();
    void activated();
    void showedEvent(QShowEvent *evt);
    void activeWindowChanged(WId);
    void setAnimationsSlot(int);
    void setHideOnClickSlot(int);

    void screensSizeChanged(int);


    void showingIconsDialog();
    void answeredIconDialog();
    void configDialogFinished();

    void saveConfigurationFiles();

private slots:
    void createConfigurationInterface(KConfigDialog *parent);

private:
    bool m_lockActivities;
    bool m_showWindows;
    int m_zoomFactor;//New properties
    int m_animations;
    bool m_windowsPreviews;
    int m_windowsPreviewsOffsetX;
    int m_windowsPreviewsOffsetY;
    int m_fontRelevance;
    bool m_showStoppedActivities;
    bool m_firstRunLiveTour;
    bool m_firstRunCalibrationPreviews;

    bool m_hideOnClick;
    bool m_isOnDashboard;

    Ui::Config m_config;
    QDesktopWidget *m_desktopWidget;

    QHash <QString,QStringList *> storedWorkareas;

    QGraphicsLinearLayout *mainLayout;
    QGraphicsWidget *m_mainWidget;

    Plasma::DeclarativeWidget *declarativeWidget;

    KConfigGroup appConfig;

    ActivityManager *actManager;
    PTaskManager *taskManager;

    QObject *mainQML;

    Plasma::ExtenderItem *item;



};

// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(WorkFlow,WorkFlow)

#endif
