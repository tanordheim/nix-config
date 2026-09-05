import QtQuick
import qs.popouts
import qs.theme

Item {
    id: root

    required property var bar

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Text {
        id: icon

        anchors.fill: parent
        text: "󰐥"
        color: root.bar.popout === "session" ? Theme.accent : Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.bar.togglePopout("session")
    }

    SessionPopout {
        bar: root.bar
        source: root
    }
}
