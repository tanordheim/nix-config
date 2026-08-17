import QtQuick
import Quickshell.Widgets
import qs.services as Services
import qs.theme

IconImage {
    id: root

    source: Services.Media.icon
    implicitSize: Theme.iconSize

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton

        onClicked: {
            if (Services.Media.active !== null && Services.Media.active.canTogglePlaying)
                Services.Media.active.togglePlaying();
        }
    }
}
