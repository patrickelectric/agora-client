import QtQuick 2.7
import QtQuick.Controls 2.1

StackView {
    property alias model: listView.model
    property alias delegate: listView.delegate

    clip: true

    id: stackView

    initialItem: ListView {
        id: listView
        spacing: internal.viewMargin
    }
}
