import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Wayland
import qs.config
import qs.popouts
import qs.services as Services
import qs.theme

Row {
    id: root

    required property var bar

    spacing: Theme.spacingLarge

    component StatusText: Text {
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.text
        textFormat: Text.PlainText
    }

    StatusText {
        text: idleInhibitor.enabled ? "󱐋" : "󰖔"
        color: idleInhibitor.enabled ? Theme.accent : Theme.text

        IdleInhibitor {
            id: idleInhibitor

            window: root.bar
        }

        MouseArea {
            anchors.fill: parent

            onClicked: idleInhibitor.enabled = !idleInhibitor.enabled
        }
    }

    Item {
        id: volumeItem

        implicitWidth: volumeLabel.implicitWidth
        implicitHeight: volumeLabel.implicitHeight

        StatusText {
            id: volumeLabel

            anchors.fill: parent
            text: {
                if (!Services.Audio.sinkAvailable)
                    return "󰕾 --";
                if (Services.Audio.sinkMuted)
                    return "󰖁 muted";
                return "󰕾 " + Services.Audio.sinkPercent + "%";
            }
            color: Services.Audio.sinkMuted ? Theme.critical : Theme.text
        }

        MouseArea {
            anchors.fill: parent

            onClicked: root.bar.togglePopout("audio")

            onWheel: wheel => {
                const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;
                if (delta !== 0)
                    Services.Audio.adjustSink(delta > 0 ? 0.05 : -0.05);
                wheel.accepted = true;
            }
        }

        AudioPopout {
            bar: root.bar
            source: volumeItem
        }
    }

    StatusText {
        id: bluetoothItem

        property int revision: 0

        readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
        readonly property var connectedDevices: (bluetoothItem.revision, Bluetooth.devices.values.filter(device => device.connected))

        text: {
            if (bluetoothItem.adapter === null || !bluetoothItem.adapter.enabled)
                return "󰂯 off";
            if (bluetoothItem.connectedDevices.length > 0)
                return "󰂯 " + bluetoothItem.connectedDevices[0].name;
            return "󰂯 on";
        }

        Instantiator {
            model: Bluetooth.devices

            Connections {
                target: modelData

                function onConnectedChanged(): void {
                    bluetoothItem.revision++;
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: Quickshell.execDetached(Config.bluetoothSettings)
        }
    }

    StatusText {
        id: networkItem

        readonly property var wired: Networking.devices.values.find(device => device.type === DeviceType.Wired) ?? null
        readonly property bool connected: networkItem.wired !== null && networkItem.wired.connected

        text: networkItem.connected ? "󰈀 " + networkItem.wired.name : "󰖪 disconnected"
        color: networkItem.connected ? Theme.text : Theme.critical

        MouseArea {
            anchors.fill: parent

            onClicked: Quickshell.execDetached(Config.networkSettings)
        }
    }

    TrayIndicator {
        bar: root.bar
    }

    Item {
        id: bellItem

        implicitWidth: bellGlyph.implicitWidth
        implicitHeight: bellGlyph.implicitHeight

        StatusText {
            id: bellGlyph

            text: Services.Notifications.dnd ? "󰂛" : "󰂚"
            color: Services.Notifications.failed ? Theme.mutedText : Theme.text
        }

        Rectangle {
            visible: Services.Notifications.hasNotifications
            implicitWidth: Math.max(Theme.badgeSize, countLabel.implicitWidth + Theme.spacingSmall)
            implicitHeight: Theme.badgeSize
            radius: height / 2
            color: Theme.critical
            anchors.top: bellGlyph.top
            anchors.right: bellGlyph.right
            anchors.topMargin: -Theme.spacingSmall
            anchors.rightMargin: -Theme.spacingSmall

            Text {
                id: countLabel

                anchors.centerIn: parent
                text: Services.Notifications.count
                color: Theme.background
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeBadge
                textFormat: Text.PlainText
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                if (mouse.button === Qt.RightButton)
                    Services.Notifications.toggleDnd();
                else
                    Services.Notifications.toggleCenter();
            }
        }
    }
}
