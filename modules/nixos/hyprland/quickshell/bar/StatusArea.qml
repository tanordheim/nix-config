import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import qs.config
import qs.services as Services
import qs.theme

Row {
    id: root

    required property var window

    spacing: Theme.spacingLarge

    component StatusText: Text {
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        color: Theme.text
        textFormat: Text.PlainText
    }

    StatusText {
        text: idleInhibitor.enabled ? "" : ""
        color: idleInhibitor.enabled ? Theme.accent : Theme.text

        IdleInhibitor {
            id: idleInhibitor

            window: root.window
        }

        MouseArea {
            anchors.fill: parent

            onClicked: idleInhibitor.enabled = !idleInhibitor.enabled
        }
    }

    StatusText {
        id: volumeItem

        readonly property PwNode sink: Pipewire.defaultAudioSink
        readonly property var audio: volumeItem.sink !== null ? volumeItem.sink.audio : null
        readonly property bool available: volumeItem.audio !== null && volumeItem.sink.ready

        text: {
            if (!volumeItem.available)
                return " --";
            if (volumeItem.audio.muted)
                return " muted";
            return " " + Math.round(volumeItem.audio.volume * 100) + "%";
        }
        color: volumeItem.available && volumeItem.audio.muted ? Theme.critical : Theme.text

        PwObjectTracker {
            objects: volumeItem.sink !== null ? [volumeItem.sink] : []
        }

        MouseArea {
            anchors.fill: parent

            onClicked: Quickshell.execDetached(Config.audioSettings)

            onWheel: wheel => {
                if (!volumeItem.available)
                    return;
                const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;
                if (delta === 0)
                    return;
                const step = delta > 0 ? 0.05 : -0.05;
                volumeItem.audio.volume = Math.max(0, Math.min(1, volumeItem.audio.volume + step));
                wheel.accepted = true;
            }
        }
    }

    StatusText {
        id: bluetoothItem

        property int revision: 0

        readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
        readonly property var connectedDevices: (bluetoothItem.revision, Bluetooth.devices.values.filter(device => device.connected))

        text: {
            if (bluetoothItem.adapter === null || !bluetoothItem.adapter.enabled)
                return " off";
            if (bluetoothItem.connectedDevices.length > 0)
                return " " + bluetoothItem.connectedDevices[0].name;
            return " on";
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

    StatusText {
        visible: SystemTray.items.values.length > 0
        text: ""
        color: Theme.mutedText
    }

    Item {
        id: bellItem

        implicitWidth: bellGlyph.implicitWidth
        implicitHeight: bellGlyph.implicitHeight

        StatusText {
            id: bellGlyph

            text: Services.Notifications.dnd ? "" : ""
            color: Services.Notifications.failed ? Theme.mutedText : Theme.text
        }

        Rectangle {
            visible: Services.Notifications.hasNotifications
            width: 6
            height: 6
            radius: 3
            color: Theme.critical
            anchors.top: bellGlyph.top
            anchors.right: bellGlyph.right
            anchors.topMargin: -1
            anchors.rightMargin: -3
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
