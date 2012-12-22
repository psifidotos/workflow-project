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


#include <Plasma/Label>
#include <Plasma/PopupApplet>
#include <plasma/widgets/declarativewidget.h>
#include <Plasma/ExtenderItem>

#include <KGlobal>
#include <KStandardDirs>
#include <KConfigGroup>

#include "activitymanager.h"
#include "ptaskmanager.h"
#include "ui_config.h"

class QDesktopWidget;
class StoredParameters;

namespace Plasma {
    class ExtenderItem;
    class Containment;
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
    virtual QGraphicsWidget *graphicsWidget();

    ///Properties
    Q_INVOKABLE void hidePopupDialog();
    Q_INVOKABLE void showPopupDialog();

    Q_INVOKABLE void updatePopWindowWId();

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
    Q_INVOKABLE int activitySize(QString id);

    Q_INVOKABLE void workAreaWasClicked();

    Q_INVOKABLE int setCurrentActivityAndDesktop(QString ,int );

protected:

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
    void configDialogAccepted();

protected slots:
  virtual void wheelEvent(QGraphicsSceneWheelEvent *event);

private slots:
    void createConfigurationInterface(KConfigDialog *parent);

private:
    bool m_isOnDashboard;

    bool m_findPopupWid;

    QGraphicsWidget *m_mainWidget;
    Plasma::DeclarativeWidget *declarativeWidget;

    QDesktopWidget *m_desktopWidget;

    ActivityManager *actManager;
    PTaskManager *taskManager;
    StoredParameters *storedParams;

    QObject *mainQML;

    Ui::Config m_config;

    QHash <QString,QStringList *> storedWorkareas;

    KConfigGroup appConfig;

};

#endif
