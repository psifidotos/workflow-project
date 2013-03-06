/*
 *   Copyright (C) 2010, 2011, 2012 Ivan Cukic <ivan.cukic(at)kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License version 2,
 *   or (at your option) any later version, as published by the Free
 *   Software Foundation
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#include <Application.h>

#include <QDebug>
#include <QDBusConnection>
#include <QThread>

#include <KCrash>
#include <KAboutData>
#include <KCmdLineArgs>
#include <KServiceTypeTrader>
#include <KSharedConfig>

#include "Store.h"

#include <signal.h>
#include <stdlib.h>
#include <memory>


Application * Application::s_instance=0;

Application::Application()
    : KUniqueApplication(),
      m_store(new Store)
{
    // TODO: We should move away from any GUI code
    setQuitOnLastWindowClosed(false);

    if (!QDBusConnection::sessionBus().registerService("org.opentoolsandspace.WorkareaManager")) {
        exit(0);
    }

    // KAMD is a daemon, if it crashes it is not a problem as
    // long as it restarts properly
    // NOTE: We have a custom crash handler
    KCrash::setFlags(KCrash::AutoRestart);
}

Application::~Application()
{
    s_instance = 0;
}

int Application::newInstance()
{
    //We don't want to show the mainWindow()
    return 0;
}

Store & Application::store() const
{
    return *m_store;
}

Application * Application::self()
{
    if (!s_instance) {
        s_instance = new Application();
    }

    return s_instance;
}

void Application::quit()
{
    if (s_instance) {
        s_instance->exit();
        delete s_instance;
    }
}



// Leaving object oriented world :)

int main(int argc, char ** argv)
{
    KAboutData about("workareamanagerd", 0, ki18n("WorkFlow Workarea Manager"), "0.1",
            ki18n("WorkFlow Workarea Management Service"),
            KAboutData::License_GPL,
            ki18n("(c) 2012, 2013 Michail Vourlakos"), KLocalizedString(),
            "http://workflow.opentoolsandspace.org/");

    KCmdLineArgs::init(argc, argv, &about);

    return Application::self()->exec();
}

