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

#include <QGraphicsLinearLayout>

#include <KGlobal>
#include <KStandardDirs>

				

class WorkflowWidget;

namespace Plasma {
  class ExtenderItem;
};
				
// Define our plasma Applet
class workflow : public Plasma::PopupApplet
{
    Q_OBJECT
    public:
        // Basic Create/Destroy
        workflow(QObject *parent, const QVariantList &args);
        ~workflow();
	
        /**
         * The widget that displays the QML class.
         */
   //     virtual QGraphicsWidget *graphicsWidget();
	
        virtual void init();    
        void initExtenderItem(Plasma::ExtenderItem *item);
    private:

	QGraphicsLinearLayout *mainLayout;
    QGraphicsWidget *m_mainWidget;

	Plasma::Label  *lbl_text;
    Plasma::DeclarativeWidget *declarativeWidget;

};
 
// This is the command that links your applet to the .desktop file
K_EXPORT_PLASMA_APPLET(workflow,workflow)

#endif
