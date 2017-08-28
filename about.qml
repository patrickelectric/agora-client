import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Flickable {
    id: flickable

    contentHeight: column.height

    Column {
        id: column

        width: parent.width
        padding: internal.viewMargin
        spacing: 15
        Image {
            width: appWindow.width/3
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: "qrc:/agora-qtconbr-icon.png"
        }
        Label {
            text: "<br/><b>Ágora Mobile for QtCon Brasil v0.1</b><br/>Este aplicativo foi desenvolvido em Qt pela <a href=\"http://qmob.solutions\" target=\"_blank\">qmob solutions</a>, especialmente para a QtCon Brasil."
            font.bold: false
            horizontalAlignment: Label.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
        }
        Label {
            text: "<b>Principais Funcionalidades</b><br/>Login pelo número de inscrição do Sympla<br/>Visualização de atividades por dia<br/>Visualização de atividades por palestrante<br/>Visualização de atividades por tag<br/>Avaliação de palestras"
            font.bold: false
            horizontalAlignment: Label.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
