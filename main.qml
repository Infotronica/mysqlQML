import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: mainWindow
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("mysql QML")

    property string archivoWS: ""
    property string urlBase: ""
    property string folderWS: ""
    property string bdMain: ""
    property string usrBD: ""
    property string pwdBD: ""
    property string urlFolder: ""
    property string urlWS: ""

    ListModel {
        id: listaModel
    }

    Component {
        id: listaDelegate

        RowLayout {
            id: listaDelegate
            spacing: -1

            Item {
                Layout.fillWidth: true
            }

            Label {
                text: "<b>N:</b> " + n
                Layout.preferredWidth: mainWindow.width*0.05
                height: 20

                background: Rectangle {
                    color: "white"
                    border.color: "black"
                    opacity: 0.70
                }
            }

            Label {
                text: "<b>Texto:</b> " + texto
                Layout.preferredWidth: mainWindow.width*0.50
                height: 20

                background: Rectangle {
                    color: "white"
                    border.color: "black"
                    opacity: 0.70
                }
            }

            Item {
                Layout.fillWidth: true
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Image {
                anchors.fill: parent
                source: "img_background/82291866_2586218914949191_3246048982811541504_o.jpg"
                fillMode: Image.PreserveAspectFit
            }

            ListView {
                id: listView
                anchors.fill: parent
                model: listaModel
                delegate: listaDelegate
                focus: true
                highlight: highlight
                highlightFollowsCurrentItem: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter

            Button {
                text: "List Names using QML JavaScript"
                onClicked: {
                    doSQLQueryJS()
                }
            }
            Button {
                text: "List Names using CPP Library"
                onClicked: {
                    doSQLQueryCPP()
                }
            }
            Button {
                text: "Clear List"
                onClicked: {
                    listaModel.clear()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.minimumHeight: mainWindow.height*0.02
        }
    }

    Component.onCompleted: {
        archivoWS="webservice.php"
        urlBase="http://127.0.0.1"
        folderWS="webservice"
        bdMain="database_names"
        usrBD="root"
        pwdBD=""

        /*
            urlFolder = "http://localhost/webservice/"
            urlWS = "http://localhost/webservice/webservice.php"
         */

        urlFolder=urlBase+"/"+folderWS+"/"
        urlWS=urlFolder+archivoWS

        localFunctions.setWS(urlWS)
        localFunctions.setBD(bdMain)
        localFunctions.setUSR(usrBD)
        localFunctions.setPWD(pwdBD)
    }

    function doSQLQueryJS()
    {
        var xmlhttp,params,sql,jsonArray,i

        xmlhttp = new XMLHttpRequest()
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState===4 && xmlhttp.status===200)
            {
                try
                {
                    jsonArray = JSON.parse(xmlhttp.responseText)
                }
                catch(e)
                {
                    // nada
                }
                listaModel.clear()
                for (i=0; i<jsonArray.length; i++)
                {
                    listaModel.append(
                        {
                          "n": jsonArray[i]["idName"],
                          "texto": jsonArray[i]["first name"]+" "+jsonArray[i]["last name"]
                        }
                    )
                }
            }
        }

        sql="select * from `list names`"
        params = "sql="+sql+"&bd="+bdMain+"&usr_bd="+usrBD+"&pwd_bd="+pwdBD

        xmlhttp.open("POST",urlWS, true)
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=UTF-8")
        xmlhttp.setRequestHeader("Content-length", params.length)
        xmlhttp.setRequestHeader("Connection", "close")
        xmlhttp.send(params)
    }

    function doSQLQueryCPP()
    {
        var sql,str,jsonArray,i

        sql="select * from `list names`"
        str=localFunctions.doSQLQuery(sql) // excec a sql query
        str=str.toString()

        jsonArray = JSON.parse(str)
        listaModel.clear()
        for (i=0; i<jsonArray.length; i++)
        {
            listaModel.append(
                {
                    "n": jsonArray[i]["idName"],
                    "texto": jsonArray[i]["first name"]+" "+jsonArray[i]["last name"]
                }
            )
        }
    }
}
