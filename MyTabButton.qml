import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

TabButton {
    property alias icon: text.text
    font.pointSize: 12
    Text {
        id: text
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 10 }
        font { family: fontAwesome.name; pointSize: 12 }
        color: (parent.checked) ? Material.accent:Material.foreground
    }
}
