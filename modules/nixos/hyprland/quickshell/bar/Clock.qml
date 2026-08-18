import QtQuick
import Quickshell
import qs.popouts
import qs.theme

Item {
    id: root

    required property var bar

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Text {
        id: label

        anchors.fill: parent
        text: Qt.formatDateTime(clock.date, "HH:mm · MMM dd")
        color: Theme.text
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.bar.togglePopout("calendar")
    }

    CalendarPopout {
        bar: root.bar
        source: root
    }
}
