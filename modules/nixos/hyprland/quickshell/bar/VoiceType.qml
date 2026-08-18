import QtQuick
import qs.services as Services
import qs.theme

Item {
    id: root

    readonly property bool highlighted: !Services.VoiceType.failed && Services.VoiceType.status !== "idle"

    implicitWidth: label.implicitWidth + 2 * Theme.spacingNormal
    implicitHeight: Theme.barHeight - 2 * Theme.spacingSmall

    Rectangle {
        width: parent.width
        height: parent.height
        radius: Theme.radius
        color: {
            if (Services.VoiceType.failed)
                return "transparent";
            if (Services.VoiceType.status === "recording")
                return Theme.critical;
            if (Services.VoiceType.status === "transcribing")
                return Theme.accent;
            return "transparent";
        }

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }
    }

    Text {
        id: label

        anchors.centerIn: parent
        text: {
            if (Services.VoiceType.failed)
                return "󰍬 unavailable";
            if (Services.VoiceType.status === "idle")
                return "󰍬";
            return "󰍬 " + Services.VoiceType.status;
        }
        color: {
            if (root.highlighted)
                return Theme.background;
            if (Services.VoiceType.failed)
                return Theme.mutedText;
            return Theme.text;
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText
    }

    MouseArea {
        anchors.fill: parent

        onClicked: Services.VoiceType.failed ? Services.VoiceType.retry() : Services.VoiceType.toggle()
    }
}
