#ifndef ICONDIALOG_H
#define ICONDIALOG_H

#include <QObject>

class IconDialog : public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE static QString getIcon();
};

#endif // ICONDIALOG_H
