import QtQuick
import qs.theme

Rectangle {
    id: root

    property alias text: label.text
    property bool interactive: true
    property bool selected: false
    property color foreground: Theme.text

    signal clicked

    implicitWidth: Math.max(Theme.rowHeight, label.implicitWidth + 2 * Theme.spacingNormal)
    implicitHeight: Theme.rowHeight
    radius: Theme.radius
    color: root.selected || (pointer.containsMouse && root.interactive) ? Theme.hoverSurface : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.animationFast
        }
    }

    Text {
        id: label

        anchors.centerIn: parent
        color: root.interactive ? root.foreground : Theme.separator
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText
    }

    MouseArea {
        id: pointer

        anchors.fill: parent
        hoverEnabled: true
        enabled: root.interactive

        onClicked: root.clicked()
    }
}
