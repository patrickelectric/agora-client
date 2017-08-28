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
            title: "Resumo"
            Label {
                text: model.abstract
                font.bold: false
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }
        MyGroupBox {
            title: "Biografia do" + ((model.speakers.length > 1) ? "s":"") + " Palestrante" + ((model.speakers.length > 1) ? "s":"")
            Column {
                width: parent.width
                spacing: 10
                Repeater {
                    model: flickable.model.speakers
                    Label {
                        text: "<b>" + modelData.name + "</b> - " + modelData.resume
                        font.bold: false
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
        MyGroupBox {
            title: "Tipo da Atividade"
            RowLayout {
                Label { text: model.activity_type.icon; font.bold: false; font { family: fontAwesome.name; pointSize: 12 } }
                Label { text: model.activity_type.name; font.bold: false }
            }
        }
        MyGroupBox {
            title: "Tags da Atividade"
            GridLayout {
                rows: flickable.model.activity_tags.length
                columns: 2
                flow: GridLayout.TopToBottom
                Repeater {
                    model: flickable.model.activity_tags
                    Label { text: modelData.icon; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font.bold: false; font { family: fontAwesome.name; pointSize: 12 } }
                }
                Repeater {
                    model: flickable.model.activity_tags
                    Label { text: modelData.name; font.bold: false }
                }
            }
        }
    }

    ScrollIndicator.vertical: ScrollIndicator { }
}
