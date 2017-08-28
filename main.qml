import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Qt.labs.settings 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: 360
    height: 640
    title: qsTr("QtCon Brasil 2017")

    Material.primary: "#05070d"
    Material.foreground: "#05070d"
    Material.accent: "#41cd52"

    property bool loggedin: userModel.json !== undefined && userModel.json["login"] !== undefined
    property string user

    header: ToolBar {
        width: parent.width
        RowLayout {
            anchors.fill: parent
            MyToolButton {
                text: (internal.currentStackView.depth == 1) ? "\uf0c9":"\uf060"
                enabled: loggedin
                onClicked: (internal.currentStackView.depth == 1) ? drawer.open():internal.currentStackView.pop()
            }
            Label {
                text: "QtCon Brasil 2017"
                font.bold: true
                color: "white"
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }
            MyToolButton {
                Image {
                    anchors.centerIn: parent
                    width: 28; height: 28
                    source: "qrc:/qt-logo.png"
                }
            }
        }
    }

    QtObject {
        id: internal
        property string baseServer: "http://agora-server.herokuapp.com"
//        property string baseServer: "http://127.0.0.1:5000"
        property real maxWidth: fontMetrics.advanceWidth("PALESTRANTES")*1.75
        property real maxIconWidth: fontMetrics.advanceWidth("\uf19d")
        property int viewMargin: 5
        property var stackViews: [ activitiesStackView, speakersStackView, tagsStackView ]
        property MyStackView currentStackView: stackViews[tabBar.currentIndex]
    }

    FontLoader { id: fontAwesome; source: "qrc:///FontAwesome.otf" }

    JSONListModel {
        id: userModel
        onStateChanged: {
            if (state == "error" && userModel.errorString === "The server returned error 0") {
                errorLabel.text = "dispositivo sem conexão\nconecte-se à Internet e tente novamente"
            }
            if (state == "ready" && userModel.json["login"] === undefined) {
                errorLabel.text = "inscrição não localizada"
            }
        }
    }
    JSONListModel { id: activitiesModel; source: internal.baseServer + "/full_activities_by_conference_and_day/1" }
    JSONListModel { id: speakersModel; source: internal.baseServer + "/full_speakers_by_conference/1" }
    JSONListModel { id: tagsModel; source: internal.baseServer + "/full_activity_tags_by_conference/1" }

    Item {
        visible: !loggedin
        anchors.fill: parent
        Column {
            anchors.centerIn: parent
            TextField {
                id: loginTextField
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "número de inscrição"
                Image {
                    anchors { bottom: loginTextField.top; bottomMargin: 60 }
                    width: appWindow.width/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/qtconbr-logo.png"
                }
            }
            Button {
                id: loginButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: "entrar"
                enabled: loginTextField.text != "" && userModel.state != "loading"
                BusyIndicator {
                    anchors { top: loginButton.bottom; horizontalCenter: parent.horizontalCenter }
                    visible: userModel.state == "loading"
                }
                Label {
                    id: errorLabel
                    horizontalAlignment: Label.AlignHCenter
                    anchors { top: loginButton.bottom; topMargin: 6; horizontalCenter: parent.horizontalCenter }
                    visible: (loginTextField.text != "" && userModel.json !== undefined && userModel.json["login"] === undefined) || userModel.errorString !== ""
                    color: "#41cd52"
                }
                onClicked: {
                    userModel.source = internal.baseServer + "/login/" + loginTextField.text
                    userModel.load()
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors { fill: parent; topMargin: internal.viewMargin; bottomMargin: internal.viewMargin }
        currentIndex: tabBar.currentIndex
        visible: loggedin

        ColumnLayout {
            ComboBox {
                id: dayCombo
                anchors { left: parent.left; right: parent.right; rightMargin: internal.viewMargin; leftMargin: internal.viewMargin }
                model: activitiesModel.json
                visible: activitiesStackView.depth == 1
                textRole: "day"
            }
            ActivitiesStackView {
                id: activitiesStackView
                Layout.fillHeight: true
                Layout.fillWidth: true
                model: (dayCombo.currentIndex != -1) ? activitiesModel.json[dayCombo.currentIndex].activities:undefined
            }
        }

        MyStackView {
            id: speakersStackView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: speakersModel.json
            delegate: Frame {
                width: parent.width
                height: speakerRow.height + 2*padding
                anchors { left: parent.left; right: parent.right; rightMargin: internal.viewMargin; leftMargin: internal.viewMargin }
                RowLayout {
                    id: speakerRow
                    Label { text: "\uf007"; font { family: fontAwesome.name; pointSize: 12 } }
                    Label { text: modelData.name + " (" + modelData.affiliation + ")" }
                }
                ItemDelegate {
                    anchors { fill: parent; margins: -11 }
                    onClicked: speakersStackView.push("qrc:/speaker.qml", { "model": speakersStackView.model[index] })
                }
            }
        }

        MyStackView {
            id: tagsStackView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: tagsModel.json
            delegate: Frame {
                width: parent.width
                height: tagRow.height + 2*padding
                anchors { left: parent.left; right: parent.right; rightMargin: internal.viewMargin; leftMargin: internal.viewMargin }
                RowLayout {
                    id: tagRow
                    Label { text: modelData.icon; Layout.preferredWidth: internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font { family: fontAwesome.name; pointSize: 12 } }
                    Label { text: modelData.name }
                }
                ItemDelegate {
                    anchors { fill: parent; margins: -11 }
                    onClicked: tagsStackView.push("qrc:/ActivitiesStackView.qml", { "model": tagsStackView.model[index].activities })
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: parent.width*3/4
        height: parent.height
        dragMargin: loggedin ? 10:0
        Image {
            id: drawerImage
            source: "qrc:/drawer.png"
            anchors.top: parent.top
            width: parent.width
            fillMode: Image.PreserveAspectFit
            Text {
                anchors { left: parent.left; leftMargin: 20; bottom: parent.bottom; bottomMargin: 5 }
                text: (userModel.json !== undefined && userModel.json["name"] !== undefined) ? (userModel.json["name"].split(" ")[0] + " " + userModel.json["name"].split(" ").slice(-1)[0]):""
                color: "#05070d"
            }
        }
        ListView {
            anchors { top: drawerImage.bottom; bottom: parent.bottom }
            width: parent.width
            clip: true
            model: ListModel {
                ListElement { icon: "\uf073"; name: "Programação"; section: "operations" }
                ListElement { icon: "\uf007"; name: "Palestrantes"; section: "operations" }
                ListElement { icon: "\uf02b"; name: "Tags"; section: "operations" }
                ListElement { icon: "\uf08b"; name: "Logout"; section: "help" }
                ListElement { icon: "\uf129"; name: "Sobre"; section: "help" }
            }
            section.property: "section"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle {
                width: parent.width
                height: 2
                color: "transparent"
                border.color: "#bdbdbd"
                Rectangle { y: 1; width: parent.width; height: 2; color: "white" }
            }

            delegate: Item {
                width: parent.width
                height: 42
                RowLayout {
                    id: menuRow
                    anchors.verticalCenter: parent.verticalCenter
                    Label { text: "   " + icon; Layout.preferredWidth: 2*internal.maxIconWidth; horizontalAlignment: Text.AlignHCenter; font { family: fontAwesome.name; pointSize: 12 } }
                    Label { text: name }
                }
                ItemDelegate {
                    id: itemDelegate
                    anchors { fill: parent }
                    onClicked: {
                        if (index <= 2)
                            tabBar.currentIndex = index
                        if (index == 3) {
                            userModel.json = undefined
                            loginTextField.text = ""
                        }
                        if (index == 4) {
                            internal.currentStackView.push("qrc:/about.qml")
                        }
                        drawer.close()
                    }
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        visible: loggedin && (activitiesModel.state == "loading" || speakersModel.state == "loading" || tagsModel.state == "loading")
    }

    Settings {
        property alias activitiesModel: activitiesModel.json
        property alias speakersModel: speakersModel.json
        property alias tagsModel: tagsModel.json
        property alias userModel: userModel.json
    }

    footer: TabBar {
        id: tabBar
        width: parent.width
        visible: loggedin
        currentIndex: swipeView.currentIndex
        MyTabButton { width: Math.max(tabBar.width/4, internal.maxWidth); text: qsTr("Programação"); icon: "\uf073" }
        MyTabButton { width: Math.max(tabBar.width/4, internal.maxWidth); text: qsTr("Palestrantes"); icon: "\uf007" }
        MyTabButton { width: Math.max(tabBar.width/4, internal.maxWidth); text: qsTr("Tags"); icon: "\uf02b" }
    }

    FontMetrics {
        id: fontMetrics
        font.family: "Awesome"
        font.pointSize: 12
    }

    onClosing : {
        if (internal.currentStackView.depth > 1) {
            internal.currentStackView.pop()
            close.accepted = false
        }
        else {
            close.accepted = true
            if (userModel.json["login"] === undefined)
                userModel.json = undefined
        }
    }

    Component.onCompleted: {
        if (activitiesModel.json === undefined)
            activitiesModel.load()
        if (speakersModel.json === undefined)
            speakersModel.load()
        if (tagsModel.json === undefined)
            tagsModel.load()
    }
}
