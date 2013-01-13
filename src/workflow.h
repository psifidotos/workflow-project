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


#include "ptaskmanager.h"
#include "ui_workflowConfig.h"

class QDesktopWidget;
class StoredParameters;
class ActivitiesEnhancedModel;
class WorkflowManager;
class PreviewsManager;

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

    //QGraphicsWidget *graphicsWidget();
    void init();

signals:
    void updateMarginForPreviews(int x, int y);
    void updateWindowIDForPreviews(QString win);

protected:
    void createConfigurationInterface(KConfigDialog *parent);
    virtual void popupEvent(bool show);


public slots:

    void geomChanged();
    void setMainWindowId();

    void setPassivePopupSlot(bool);

    void activeWindowChanged(WId);

    void showingIconsDialog();
    void answeredIconDialog();

    void configDialogFinished();
    void configChanged();

    void workAreaWasClickedSlot();
    Q_INVOKABLE void updatePopWindowWIdSlot();

    void hidePopupDialogSlot();
    void showPopupDialogSlot();

    void setActivityNameIconSlot(QString, QString);

protected slots:
    virtual void wheelEvent(QGraphicsSceneWheelEvent *event);
    void configAccepted();

private:
    Ui::workflowConfig ui;

    bool m_isOnDashboard;
    bool m_findPopupWid;
    QString m_activityIcon;
    QString m_activityName;
    QString m_windowID;

    QObject *m_rootQMLObject;
    QDesktopWidget *m_desktopWidget;
    Plasma::Svg *m_theme;

    QGraphicsWidget *m_mainWidget;
    Plasma::DeclarativeWidget *declarativeWidget;

    ActivitiesEnhancedModel *m_activitiesModel;
    WorkflowManager *m_workflowManager;
    StoredParameters *m_storedParams;
    PTaskManager *m_taskManager;
    PreviewsManager *m_previewManager;

    void paintIcon();
    void initTooltip();

};

// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(workflow, WorkFlow)

#endif
