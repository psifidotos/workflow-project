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

#include <Plasma/Svg>
#include <Plasma/Theme>
#include <Plasma/Label>
#include <Plasma/PopupApplet>
#include <plasma/widgets/declarativewidget.h>
#include <Plasma/ExtenderItem>

#include <KGlobal>
#include <KStandardDirs>
#include <KConfigGroup>

#include "activitymanager.h"
#include "ptaskmanager.h"
#include "workareasmanager.h"
#include "ui_workflowConfig.h"

class QDesktopWidget;
class StoredParameters;

namespace Plasma {
class ExtenderItem;
class Containment;
class Svg;
}


// Define our plasma Applet
class WorkFlow : public Plasma::PopupApplet
{
    Q_OBJECT

public:
    WorkFlow(QObject *parent, const QVariantList &args);
    ~WorkFlow();

    void init();
    QGraphicsWidget *graphicsWidget();

protected:
    void createConfigurationInterface(KConfigDialog *parent);
    virtual void popupEvent(bool show);


public slots:

    void geomChanged();
    void setMainWindowId();

    void setPassivePopupSlot(bool);

    void activeWindowChanged(WId);

    void screensSizeChanged(int);

    void showingIconsDialog();
    void answeredIconDialog();

    void configDialogFinished();
    void configChanged();

    void workAreaWasClickedSlot();
    void updatePopWindowWIdSlot();

    void hidePopupDialogSlot();
    void showPopupDialogSlot();

    void setActivityNameIconSlot(QString, QString);

protected slots:
    virtual void wheelEvent(QGraphicsSceneWheelEvent *event);
    void configAccepted();

private:
    bool m_isOnDashboard;

    bool m_findPopupWid;

    QGraphicsWidget *m_mainWidget;
    Plasma::DeclarativeWidget *declarativeWidget;

    QDesktopWidget *m_desktopWidget;

    ActivityManager *m_actManager;
    PTaskManager *m_taskManager;
    WorkareasManager *m_workareasManager;
    StoredParameters *m_storedParams;

    QObject *m_rootQMLObject;

    Ui::workflowConfig ui;

    KConfigGroup appConfig;

    Plasma::Svg *m_theme;

    QString m_activityIcon;
    QString m_activityName;

    void paintIcon();

};


#endif
