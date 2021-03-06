/*
 * This file was generated by qdbusxml2cpp version 0.7
 * Command line was: qdbusxml2cpp -v -c WorkareaInterface -p workareainterface.h:workareainterface.cpp ../org.opentoolsandspace.WorkareaManager.xml
 *
 * qdbusxml2cpp is Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
 *
 * This is an auto-generated file.
 * Do not edit! All changes made to it will be lost.
 */

#ifndef WORKAREAINTERFACE_H
#define WORKAREAINTERFACE_H

#include <QtCore/QObject>
#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QMap>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QVariant>
#include <QtDBus/QtDBus>

/*
 * Proxy class for interface org.opentoolsandspace.WorkareaManager
 */
class WorkareaInterface: public QDBusAbstractInterface
{
    Q_OBJECT
public:
    static inline const char *staticInterfaceName()
    { return "org.opentoolsandspace.WorkareaManager"; }

public:
    WorkareaInterface(const QString &service, const QString &path, const QDBusConnection &connection, QObject *parent = 0);

    ~WorkareaInterface();

public Q_SLOTS: // METHODS
    inline QDBusPendingReply<QStringList> Activities()
    {
        QList<QVariant> argumentList;
        return asyncCallWithArgumentList(QLatin1String("Activities"), argumentList);
    }

    inline QDBusPendingReply<QStringList> ActivityBackgrounds(const QString &actId)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(actId);
        return asyncCallWithArgumentList(QLatin1String("ActivityBackgrounds"), argumentList);
    }

    inline QDBusPendingReply<> AddWorkarea(const QString &id, const QString &name)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(id) << QVariant::fromValue(name);
        return asyncCallWithArgumentList(QLatin1String("AddWorkarea"), argumentList);
    }

    inline QDBusPendingReply<> CloneActivity(const QString &in0)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(in0);
        return asyncCallWithArgumentList(QLatin1String("CloneActivity"), argumentList);
    }

    inline QDBusPendingReply<int> MaxWorkareas()
    {
        QList<QVariant> argumentList;
        return asyncCallWithArgumentList(QLatin1String("MaxWorkareas"), argumentList);
    }

    inline QDBusPendingReply<> MoveActivity(const QString &in0, int in1)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(in0) << QVariant::fromValue(in1);
        return asyncCallWithArgumentList(QLatin1String("MoveActivity"), argumentList);
    }

    inline QDBusPendingReply<> RemoveWorkarea(const QString &id, int desktop)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(id) << QVariant::fromValue(desktop);
        return asyncCallWithArgumentList(QLatin1String("RemoveWorkarea"), argumentList);
    }

    inline QDBusPendingReply<> RenameWorkarea(const QString &id, int desktop, const QString &name)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(id) << QVariant::fromValue(desktop) << QVariant::fromValue(name);
        return asyncCallWithArgumentList(QLatin1String("RenameWorkarea"), argumentList);
    }

    inline QDBusPendingReply<bool> ServiceStatus()
    {
        QList<QVariant> argumentList;
        return asyncCallWithArgumentList(QLatin1String("ServiceStatus"), argumentList);
    }

    inline QDBusPendingReply<> SetCurrentNextActivity()
    {
        QList<QVariant> argumentList;
        return asyncCallWithArgumentList(QLatin1String("SetCurrentNextActivity"), argumentList);
    }

    inline QDBusPendingReply<> SetCurrentPreviousActivity()
    {
        QList<QVariant> argumentList;
        return asyncCallWithArgumentList(QLatin1String("SetCurrentPreviousActivity"), argumentList);
    }

    inline QDBusPendingReply<QStringList> Workareas(const QString &actId)
    {
        QList<QVariant> argumentList;
        argumentList << QVariant::fromValue(actId);
        return asyncCallWithArgumentList(QLatin1String("Workareas"), argumentList);
    }

Q_SIGNALS: // SIGNALS
    void ActivityAdded(const QString &id);
    void ActivityInfoUpdated(const QString &id, const QStringList &backgrounds, const QStringList &workareas);
    void ActivityOrdersChanged(const QStringList &activities);
    void ActivityRemoved(const QString &id);
    void MaxWorkareasChanged(int in0);
    void ServiceStatusChanged(bool in0);
    void WorkareaAdded(const QString &id, const QStringList &workareas);
    void WorkareaRemoved(const QString &id, const QStringList &workareas);
};

namespace org {
  namespace opentoolsandspace {
    typedef ::WorkareaInterface WorkareaManager;
  }
}
#endif
