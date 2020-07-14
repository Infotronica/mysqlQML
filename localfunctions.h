#ifndef LOCALFUNCTIONS_H
#define LOCALFUNCTIONS_H

#include <QObject>
#include <QtNetwork>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QEventLoop>
#include <QUrlQuery>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

class LocalFunctions : public QObject
{
    Q_OBJECT

private:
    QString m_urlWS,m_bdMain,m_usrBD,m_pwdBD;

public:
    explicit LocalFunctions(QObject *parent = nullptr);
    Q_INVOKABLE QByteArray doSQLQuery(QString sql);
    Q_INVOKABLE void setWS(QString urlWS);
    Q_INVOKABLE void setBD(QString bdMain);
    Q_INVOKABLE void setUSR(QString usrBD);
    Q_INVOKABLE void setPWD(QString pwdBD);
    Q_INVOKABLE QString urlWS();
    Q_INVOKABLE QString bdMain();
    Q_INVOKABLE QString usrBD();
    Q_INVOKABLE QString pwdBD();
};

#endif // LOCALFUNCTIONS_H
