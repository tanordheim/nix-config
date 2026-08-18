import QtQuick
import Quickshell.Widgets
import qs.services as Services
import qs.theme

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function formatTime(seconds: real): string {
        const total = Math.max(0, Math.floor(seconds));
        const minutes = Math.floor(total / 60);
        const secs = String(total % 60).padStart(2, "0");
        if (minutes < 60)
            return minutes + ":" + secs;
        return Math.floor(minutes / 60) + ":" + String(minutes % 60).padStart(2, "0") + ":" + secs;
    }

    Row {
        id: row

        spacing: Theme.spacingSmall

        IconImage {
            visible: Services.Media.icon !== ""
            source: Services.Media.icon
            implicitSize: Theme.iconSize

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible: Services.Media.icon === ""
            text: "󰝚"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible: Services.Media.timeAvailable
            text: root.formatTime(Services.Media.position) + "/" + root.formatTime(Services.Media.length)
            color: Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton

        onClicked: {
            if (Services.Media.active !== null && Services.Media.active.canTogglePlaying)
                Services.Media.active.togglePlaying();
        }
    }
}
