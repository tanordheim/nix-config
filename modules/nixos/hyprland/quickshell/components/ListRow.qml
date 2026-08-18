import QtQuick
import qs.theme

Rectangle {
    id: root

    property bool interactive: true
    property bool selected: false

    default property alias content: layout.data

    signal clicked(int button)

    implicitWidth: layout.implicitWidth + 2 * Theme.spacingNormal
    implicitHeight: Math.max(Theme.rowHeight, layout.implicitHeight + Theme.spacingSmall)
    radius: Theme.radius
    color: {
        if (root.selected)
            return Theme.hoverSurface;
        if (pointer.containsMouse && root.interactive)
            return Theme.hoverSurface;
        return "transparent";
    }

    Behavior on color {
        ColorAnimation {
            duration: Theme.animationFast
        }
    }

    Row {
        id: layout

        anchors.fill: parent
        anchors.leftMargin: Theme.spacingNormal
        anchors.rightMargin: Theme.spacingNormal
        spacing: Theme.spacingNormal
    }

    MouseArea {
        id: pointer

        anchors.fill: parent
        hoverEnabled: true
        enabled: root.interactive
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onClicked: mouse => root.clicked(mouse.button)
    }
}
