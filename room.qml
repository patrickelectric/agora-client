import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: item

    property var model
    property StackView stackView

    QtObject {
        id: internal
        property int padding: 10
    }

    Column {
        anchors.fill: parent
        padding: internal.padding
        spacing: 15
        GroupBox {
            title: "Activities in " + model.name
            width: parent.width-2*internal.padding
            height: parent.height-2*internal.padding
            ListView {
                anchors.fill: parent
                model: item.model.activities
                delegate: ItemDelegate {
                    text: modelData.title
                    width: parent.width
                }
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: stackView.pop()
    }
}
