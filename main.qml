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
        Item {
            width: 450
            height: 20

            Row {
                spacing: -1
                Rectangle {
                    width: mainWindow.width*0.10;
                    height: 20;
                    color: "transparent";
                    border.color: "black";
                    Text {
                        text: "<b>N:</b> " + n
                    }
                }
                Rectangle {
                    width: mainWindow.width*0.90;
                    height: 20;
                    color: "transparent";
                    border.color: "black";
                    Text {
                        text: "<b>Texto:</b> " + texto
                    }
                }
            }
        }
    }

    ColumnLayout { // contenedor para objetos en columna
        anchors.fill: parent

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: listaModel
            delegate: listaDelegate
            focus: true
            highlight: highlight
            highlightFollowsCurrentItem: false
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
        archivoWS="webservice.php";
        urlBase="http://127.0.0.1";
        folderWS="webservice";
        bdMain="database_names";
        usrBD="root";
        pwdBD="";

        /*
            urlFolder = "http://localhost/webservice/"
            urlWS = "http://localhost/webservice/webservice.php"
         */

        urlFolder=urlBase+"/"+folderWS+"/";
        urlWS=urlFolder+archivoWS;

        localFunctions.setWS(urlWS)
        localFunctions.setBD(bdMain)
        localFunctions.setUSR(usrBD)
        localFunctions.setPWD(pwdBD)
    }

    function doSQLQueryJS() {
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

    function doSQLQueryCPP() {
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
