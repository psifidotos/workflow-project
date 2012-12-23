#include "plugincloneactivity.h"

#include <QDebug>
#include <QTimer>
#include <QFile>
#include <QTextStream>

#include <KActivities/Controller>
#include <KConfigGroup>
#include <KConfig>
#include <KStandardDirs>

#include <taskmanager/taskmanager.h>


PluginCloneActivity::PluginCloneActivity(QObject *parent, KActivities::Controller *actControl) :
    QObject(parent),
    m_activitiesCtrl(actControl),
    m_currentActivityInBegin(""),
    m_fromActivity(""),
    m_toActivity(""),
    m_timerPhase(0)
{
    m_taskMainM = TaskManager::TaskManager::self();
    m_timer = new QTimer(this);

    init();
}

PluginCloneActivity::~PluginCloneActivity()
{
}

void PluginCloneActivity::init()
{
    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_timer, SIGNAL(timeout()), this, SLOT(timerTrigerred()));
}

void PluginCloneActivity::timerTrigerred(){
    QString cacheFile;

    if(m_timerPhase == 2)
        cacheFile = m_fromActivity;
    else if (m_timerPhase == 4)
        cacheFile = m_toActivity;

    if((m_timerPhase==2)||(m_timerPhase==4)){
        QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+cacheFile;

        QString line;

        QFile file(fPath);
        QTextStream stream ( &file );

        if (!file.open(QIODevice::ReadWrite)){
            qDebug() << "Error file found for "<<cacheFile;
            //return -1;
        }

        line = stream.readLine();

        if(!line.isNull()){
            m_timer->stop();

            file.close();

            if(m_timerPhase == 2)
                loadCloneActivitySettings();
            else if (m_timerPhase == 4)
                storeCloneActivitySettings();

            m_timerPhase = 0;
            m_timer->stop();
        }
        else{
            file.close();
        }

    }
    else
        m_timer->stop();

}

void PluginCloneActivity::initCloningPhase02()
{
    m_timerPhase = 2;
    m_timer->start(300);
}

void PluginCloneActivity::initCloningPhase04()
{
    m_timerPhase = 4;
    m_timer->start(300);
}


void PluginCloneActivity::initCloningPhase05()
{
    emit updateWallpaper(m_toActivity);

    m_fromActivity = "";
    m_toActivity = "";

    emit cloningEnded();
}

QString PluginCloneActivity::getContainmentId(QString txt) const
{
    QString findText1 = "[Containments][";
    QString findText2 = "]";

    int p1 = txt.indexOf(findText1)+findText1.length();
    int p2 = txt.indexOf(findText2,p1);

    QString res(txt.mid(p1,p2-p1));
    return res;
}


int PluginCloneActivity::loadCloneActivitySettings(){
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+m_fromActivity;
    // qDebug() << "Load file:"<<fPath<<"...";

    QString line;

    QFile file(fPath);
    QTextStream stream ( &file );

    m_fromCloneActivityText.clear();
    //This is done until the stopped activities properties to be written
    //This function must be called only for Stopped Activities

    //   while (line.isNull()){
    if (!file.open(QIODevice::ReadWrite)){
        qDebug() << "Error file found...";
        return -1;
    }

    line = stream.readLine();

    //    if(line.isNull())
    //         file.close();
    //  }
    //This is done until the stopped activities properties to be written

    while (!line.isNull()) {
        m_fromCloneActivityText.append(line+'\n');
        line = stream.readLine();
        //   qDebug() << "----- " <<line;
    }

    file.close();

    //  qDebug() << fromCloneActivityText;

    //fromCloneActivityId = id;
    m_fromActivityContainmentId = getContainmentId(m_fromCloneActivityText);

    //QMetaObject::invokeMethod(qmlActEngine, "initPhase02Completed");
    m_activitiesCtrl->startActivity(m_fromActivity);

    return 0;
}



int PluginCloneActivity::storeCloneActivitySettings(){
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+m_toActivity;

    QString line;

    QFile file(fPath);
    QTextStream stream ( &file );

    QString fContent;
    fContent.clear();
    //This is done until the stopped activities properties to be written
    //This function must be called only for Stopped Activities
    //    while (line.isNull()){

    if (!file.open(QIODevice::ReadWrite)){
        qDebug() << "Error file found...";
        return -1;
    }

    line = stream.readLine();

    //        if(line.isNull())
    //           file.close();
    //   }
    //This is done until the stopped activities properties to be written

    while (!line.isNull()) {
        fContent.append(line+'\n');
        line = stream.readLine();
    }

    file.close();

    //qDebug() << fContent;

    m_toActivityContainmentId = getContainmentId(fContent);

    //qDebug() << "-----------To:"<<toCloneActivityId;

    QString fromStr(QString("[Containments][")+m_fromActivityContainmentId+"]");
    QString toStr(QString("[Containments][")+m_toActivityContainmentId+"]");

    QString writeToFileRes = m_fromCloneActivityText.replace(fromStr,toStr);

    QString fromStr2("activityId="+m_fromActivityContainmentId);
    QString toStr2("activityId="+m_toActivityContainmentId);

    writeToFileRes = writeToFileRes.replace(fromStr2,toStr2);

    //qDebug() << writeToFileRes;

    if (!file.open(QIODevice::WriteOnly)){
        qDebug() << "Error file found...";
        return -1;
    }

    /* Check it opened OK */
    if(!file.isOpen()){
        qDebug() << "- Error, unable to open" << fPath << "for output";
        return -1;
    }

    stream << writeToFileRes;

    file.close();

    //  QMetaObject::invokeMethod(qmlActEngine, "initPhase04Completed");
    // After Storing the file....
    //////////////////////

    m_activitiesCtrl->startActivity(m_toActivity);

    m_activitiesCtrl->setCurrentActivity(m_currentActivityInBegin);

    return 0;
}


void PluginCloneActivity::activityStateChangedSlot()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    const QString id = activity->id();
    if (!activity) {
        return;
    }
    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    //  qDebug()<<id<<" "<<state;

    //Various Phases of Cloning
    //This is Phase02 of Cloning
    if( (id == m_fromActivity) &&
            (state == "Stopped")){
        initCloningPhase02();
    }

    //This is Phase03 of Cloning
    if( (id == m_fromActivity) &&
            (state == "Running"))
        m_activitiesCtrl->stopActivity(m_toActivity);

    //This is Phase04 of Cloning
    if( (id == m_toActivity) &&
            (state == "Stopped"))
        initCloningPhase04();
    else if ( (id == m_toActivity) &&   //Final Phase-05
              (state == "Running"))
        initCloningPhase05();

}


//Phase-01
void PluginCloneActivity::activityAddedSlot(QString actId)
{
    if(m_fromActivity != ""){
        m_toActivity = actId;

        KActivities::Info *activityFrom = new KActivities::Info(m_fromActivity, this);
        KActivities::Info *activityTo = new KActivities::Info(m_toActivity, this);

        connect(activityFrom, SIGNAL(stateChanged(KActivities::Info::State)), this,SLOT(activityStateChangedSlot()));
        connect(activityTo, SIGNAL(stateChanged(KActivities::Info::State)), this,SLOT(activityStateChangedSlot()));


        m_activitiesCtrl->setActivityName(m_toActivity,QString(tr("Copy of ")+activityFrom->name()));
        m_activitiesCtrl->setActivityIcon(m_toActivity,activityFrom->icon());

        emit copyWorkareas(m_fromActivity, m_toActivity);

       // m_plasmoid->setCurrentActivityAndDesktop(m_toActivity, m_taskMainM->currentDesktop());
        m_activitiesCtrl->setCurrentActivity(m_toActivity);

        m_activitiesCtrl->stopActivity(m_fromActivity);
    }

}


//Phase-00
void PluginCloneActivity::execute(QString actId)
{
    m_currentActivityInBegin = m_activitiesCtrl->currentActivity();

    emit cloningStarted();

    m_fromActivity = actId;

    m_toActivity = m_activitiesCtrl->addActivity(tr("New Activity"));
}


#include "plugincloneactivity.moc"
