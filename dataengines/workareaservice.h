/*
 *   Copyright 2010 Chani Armitage <chani@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef VIRTUALDESKTOP_SERVICE_H
#define VIRTUALDESKTOP_SERVICE_H

#include "workareaengine.h"

#include <Plasma/Service>
#include <Plasma/ServiceJob>

using namespace Plasma;

class WorkareaInterface;

class WorkareaService : public Plasma::Service
{
    Q_OBJECT

public:
    WorkareaService(const QString &source, WorkareaInterface *store);
    ServiceJob *createJob(const QString &operation,
                          QMap<QString, QVariant> &parameters);

private:
    QString m_id;
    WorkareaInterface *m_store;
};

#endif
