#include "localfunctions.h"

LocalFunctions::LocalFunctions(QObject *parent) : QObject(parent)
{
}

QByteArray LocalFunctions::doSQLQuery(QString sql)
{
    QNetworkAccessManager networkManager;
    QNetworkReply *networkReply;
    QNetworkRequest networkRequest;
    QByteArray postData;
    QUrlQuery urlQuery; // the "urlQuery" object stores the 4 parameters sent to webservice.php
    QEventLoop qEventLoop;

    /*
        This function makes sql requests to the database server, the way to do it is
        accessing a file called webservice.php, to which 4 data are sent, which are the following:
            1.- The sql statement in the "sql" variable
            2.- The name of the database in the variable "bdMain"
            3.- The name of the user who can use the database in the variable "usrBD"
            4.- The user's password in the variable "pwdBD"

        urlWS contains the address to the webservice.php file, in this case its value is
        "http://localhost/webservice/webservice.php"
    */

    networkRequest.setUrl(QUrl(m_urlWS));
    urlQuery.addQueryItem("sql",sql);
    urlQuery.addQueryItem("bd",m_bdMain);
    urlQuery.addQueryItem("usr_bd",m_usrBD);
    urlQuery.addQueryItem("pwd_bd",m_pwdBD);
    postData.append(urlQuery.toString()); // pass parameters to a set of bytes

    // The networkRequest variable does sets the format of the data exchange and its length
    networkRequest.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded;charset=UTF-8");
    networkRequest.setHeader(QNetworkRequest::ContentLengthHeader,postData.length());

    /*
        Here we contact webservice.php passing the 4 parameters to make the query
        in the database, the variable "networkReply" receives the information that the file returns
        webservice.php
    */
    networkReply = networkManager.post(networkRequest,postData);

    /*
        Wait for the webservice.php to finish its work WITHOUT interrupting the fluidity of the application, that is, the
        application does not freeze while waiting for the completion of this operation
    */
    connect(networkReply,SIGNAL(finished()),&qEventLoop,SLOT(quit()));
    qEventLoop.exec();
    disconnect(networkReply,SIGNAL(finished()),&qEventLoop,SLOT(quit()));

    postData=networkReply->readAll(); // Receive the data provided by webservice.php
    delete networkReply; // Delete "networkReply" object

    return postData;
}

void LocalFunctions::setWS(QString urlWS)
{
    m_urlWS=urlWS;
}

void LocalFunctions::setBD(QString bdMain)
{
    m_bdMain=bdMain;
}

void LocalFunctions::setUSR(QString usrBD)
{
    m_usrBD=usrBD;
}

void LocalFunctions::setPWD(QString pwdBD)
{
    m_pwdBD=pwdBD;
}

QString LocalFunctions::urlWS()
{
    return m_urlWS;
}

QString LocalFunctions::bdMain()
{
    return m_bdMain;
}

QString LocalFunctions::usrBD()
{
    return m_usrBD;
}

QString LocalFunctions::pwdBD()
{
    return m_pwdBD;
}
