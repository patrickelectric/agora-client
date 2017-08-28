import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Flickable {
    id: flickable

    property var model

    contentHeight: column.height

    Column {
        id: column

        width: parent.width
        padding: internal.viewMargin
        spacing: 15
        MyGroupBox {
            title: "Afiliação"
            Label {
                text: model.affiliation
                font.bold: false
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
        MyGroupBox {
            title: "Biografia do Palestrante"
            Label {
                text: model.resume
                font.bold: false
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Ver atividades de " + model.name.split(" ")[0]
            onClicked:  speakersStackView.push("qrc:/ActivitiesStackView.qml", { "model": model.activities })
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
