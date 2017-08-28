import QtQuick 2.7
import QtQuick.Controls 2.1

GroupBox {
    id: control

    font.bold: true
    width: parent.width-2*internal.viewMargin

    topPadding: (padding + (label && label.implicitWidth > 0 ? label.implicitHeight + spacing : 0))-10
    background: Rectangle {
        y: control.topPadding - control.padding
        width: parent.width
        height: parent.height - control.topPadding + control.padding

        color: "transparent"
        border.color: "#ffffff"
        border.width: 0
    }
}
