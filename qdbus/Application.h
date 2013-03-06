/*
 *   Copyright (C) 2012 Ivan Cukic <ivan.cukic(at)kde.org>
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

#ifndef APPLICATION_H
#define APPLICATION_H

#include <KUniqueApplication>
//#include <utils/d_ptr.h>

class Store;
class ApplicationPrivate;

/**
 * Main application object
 */
class Application: public KUniqueApplication {
    Q_OBJECT

public:
    virtual int newInstance();

    static Application * self();
    static void quit();

    Store  & store()  const;

private Q_SLOTS:

private:
    Application();
    virtual ~Application();

    Store  * m_store;

    static Application * s_instance;
    //Q_DECLARE_PRIVATE(Application);
    //D_PTR;
};

#endif // APPLICATION_H
