import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Popout {
    id: root

    name: "audio"

    component Level: Row {
        id: level

        required property PwNode node
        required property string mutedIcon
        required property string activeIcon

        readonly property PwNodeAudio audio: level.node !== null ? level.node.audio : null
        readonly property bool muted: level.audio !== null && level.audio.muted

        signal toggleMute

        spacing: Theme.spacingNormal

        IconButton {
            text: level.muted ? level.mutedIcon : level.activeIcon
            foreground: level.muted ? Theme.critical : Theme.text
            interactive: level.audio !== null

            anchors.verticalCenter: parent.verticalCenter

            onClicked: level.toggleMute()
        }

        VolumeSlider {
            node: level.node

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: level.audio !== null ? Math.round(level.audio.volume * 100) + "%" : "--"
            color: Theme.text
            width: percentMetrics.width
            horizontalAlignment: Text.AlignRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    TextMetrics {
        id: percentMetrics

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        text: "100%"
    }

    SectionHeader {
        text: "Output"
    }

    Level {
        node: Services.Audio.sink
        mutedIcon: "󰖁"
        activeIcon: "󰕾"

        onToggleMute: Services.Audio.toggleSinkMute()
    }

    Repeater {
        model: Services.Audio.sinks

        delegate: ListRow {
            id: device

            required property PwNode modelData

            width: root.contentWidth
            selected: Services.Audio.sink === device.modelData

            onClicked: Services.Audio.selectSink(device.modelData)

            Text {
                text: Services.Audio.nodeLabel(device.modelData)
                color: device.selected ? Theme.accent : Theme.text
                width: Math.min(implicitWidth, Theme.textColumnWidth)
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                textFormat: Text.PlainText

                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    SectionHeader {
        text: "Input"
    }

    Level {
        node: Services.Audio.source
        mutedIcon: "󰍭"
        activeIcon: "󰍬"

        onToggleMute: Services.Audio.toggleSourceMute()
    }

    IconButton {
        text: "󰒓 pavucontrol"

        onClicked: {
            Quickshell.execDetached(Config.audioSettings);
            root.bar.closePopout();
        }
    }
}
