import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

MyStackView {
    id: thisStackView
    delegate: Frame {
        width: parent.width
        height: grid.height + 2*padding
        anchors { left: parent.left; right: parent.right; rightMargin: internal.viewMargin; leftMargin: internal.viewMargin }
        GridLayout {
            id: grid
            columns: 2
            rows: 2 + modelData.speakers.length + ((modelData.room !== undefined) ? 1:0)
            flow: GridLayout.TopToBottom
            Label { text: "\uf017"; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font { family: fontAwesome.name; pointSize: 12 } }
            Label { text: "\uf041"; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; visible: modelData.room !== undefined; font { family: fontAwesome.name; pointSize: 12 } }
            Label { text: (modelData.activity_type !== undefined) ? modelData.activity_type.icon:"\uf00c"; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font { family: fontAwesome.name; pointSize: 12 } }
            Repeater {
                model: modelData.speakers
                Label { text: "\uf007"; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font { family: fontAwesome.name; pointSize: 12 } }
            }
            Label { text: modelData.start_date.substring(11, 16) + " ‒ " + modelData.end_date.substring(11, 16) }
            Label { text: (visible) ? (modelData.room.name + " ‒ " + modelData.room.location):""; visible: modelData.room !== undefined }
            Label { id: titleLabel; color: "#1c274a"; text: modelData.title; Layout.preferredWidth: thisStackView.width*0.8; wrapMode: Text.WordWrap }
            Repeater {
                model: modelData.speakers
                Label { text: modelData.name + " (" + modelData.affiliation + ")" }
            }
        }
        ItemDelegate {
            anchors { fill: parent; margins: -11 }
            onClicked: {
                if (modelData.abstract)
                    thisStackView.push("qrc:/activity.qml", { "model": thisStackView.model[index] })
            }
        }
    }
}
