#include "icondialog.h"

#include <KIconDialog>

QString IconDialog::getIcon()
{
    KIconDialog *dialog = new KIconDialog();
    dialog->setModal(true);
    dialog->setup(KIconLoader::Desktop);
    dialog->setProperty("DoNotCloseController", true);
    //KWindowSystem::setOnDesktop(dialog->winId(), KWindowSystem::currentDesktop());
    dialog->showDialog();
    //KWindowSystem::forceActiveWindow(dialog->winId());

    QString icon = dialog->openDialog();
    dialog->deleteLater();

    return icon;
}

#include <icondialog.moc>
