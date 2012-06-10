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

#include "workflow.h"


#include <Plasma/Extender>
#include <Plasma/ExtenderItem>
#include <Plasma/ToolTipManager>

workflow::workflow(QObject *parent, const QVariantList &args)
: Plasma::PopupApplet(parent, args),
m_mainWidget(0)
{
    setPopupIcon("preferences-activities");
    setAspectRatioMode(Plasma::IgnoreAspectRatio);
}

workflow::~workflow()
{

}
/*
QGraphicsWidget *workflow::graphicsWidget()
{  
  return m_workWidget;
}*/

void workflow::init(){

    Plasma::ToolTipManager::self()->registerWidget(this);
    extender()->setEmptyExtenderMessage(i18n("No Activities..."));
    // don't grow too much height
    //extender()->setMaximumHeight(300);
    if (extender()->item("Activities") == 0) {
      // create the item
      Plasma::ExtenderItem *item = new Plasma::ExtenderItem(extender());
      // initialize the item
      initExtenderItem(item);
      // set item name and title
      item->setName("Activities");
      item->setTitle("Activities");
    }
    // connect data sources
}

void workflow::initExtenderItem(Plasma::ExtenderItem *item) {

    m_mainWidget = new QGraphicsWidget(this);
    m_mainWidget->setPreferredSize(350, 200);
    //m_mainWidget->setMinimumSize(50,50);

    mainLayout = new QGraphicsLinearLayout(m_mainWidget);
    mainLayout->setOrientation(Qt::Vertical);
    mainLayout->setContentsMargins(0, 0, 0, 0);
    mainLayout->setSpacing(0);

    KStandardDirs *sd =    KGlobal::dirs();

    QString path =  sd->findResource("data","plasma-workflowplasmoid/qml/Activities2.qml");

    declarativeWidget = new Plasma::DeclarativeWidget(this);
    declarativeWidget->setInitializationDelayed(true);
    declarativeWidget->setQmlPath(path);
   // declarativeWidget->engine();

  //  QString mainText("Hello World!!!\n.....second line - change - ......\n");
  //  mainText.append(path);

  //  lbl_text->setText(mainText.toUtf8().constData());

   // mainLayout->addItem(lbl_text);
    mainLayout->addItem(declarativeWidget);


    m_mainWidget->setLayout(mainLayout);

    item->setWidget(m_mainWidget);
}

   
#include "workflow.moc"
   
