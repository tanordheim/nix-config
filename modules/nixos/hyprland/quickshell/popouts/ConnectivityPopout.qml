import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Widgets
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Popout {
    id: root

    property string tab: "network"
    property int revision: 0

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property var connectedDevices: (root.revision, Bluetooth.devices.values.filter(device => device.connected))
    readonly property var pairedDevices: (root.revision, Bluetooth.devices.values.filter(device => device.paired && !device.connected))

    name: "connectivity"
    contentWidth: Theme.popoutWidthWide

    function linkState(): string {
        if (Services.Connectivity.connected)
            return "Connected";
        if (Services.Connectivity.hasLink)
            return "Link, no address";
        return "Disconnected";
    }

    function linkColor(): color {
        if (Services.Connectivity.connected)
            return Theme.success;
        if (Services.Connectivity.hasLink)
            return Theme.warning;
        return Theme.critical;
    }

    function interfaceLabel(): string {
        if (Services.Connectivity.interfaceName === "")
            return "--";
        if (Services.Connectivity.linkSpeed <= 0)
            return Services.Connectivity.interfaceName;
        return Services.Connectivity.interfaceName + " · " + Services.Connectivity.linkSpeed + " Mb/s";
    }

    Binding {
        target: Services.Connectivity
        property: "panelOpen"
        value: true
        when: root.visible
        restoreMode: Binding.RestoreBindingOrValue
    }

    Instantiator {
        model: Bluetooth.devices

        Connections {
            target: modelData

            function onConnectedChanged(): void {
                root.revision++;
            }

            function onPairedChanged(): void {
                root.revision++;
            }
        }
    }

    component DeviceRow: ListRow {
        id: device

        required property BluetoothDevice modelData

        readonly property string iconSource: device.modelData.icon !== "" ? Quickshell.iconPath(device.modelData.icon, true) : ""

        onClicked: {
            if (device.modelData.connected)
                device.modelData.disconnect();
            else
                device.modelData.connect();
        }

        IconImage {
            visible: device.iconSource !== ""
            source: device.iconSource
            implicitSize: Theme.iconSize

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible: device.iconSource === ""
            text: "󰂯"
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: device.modelData.name
            color: Theme.text
            width: Math.min(implicitWidth, Theme.textColumnWidth)
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            visible: device.modelData.batteryAvailable
            text: Math.round(device.modelData.battery * 100) + "%"
            color: Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: BluetoothDeviceState.toString(device.modelData.state)
            color: device.modelData.connected ? Theme.success : Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    component InfoRow: Item {
        id: infoRow

        required property string label
        required property string value
        property color valueColor: Theme.text
        property bool copyable: false

        implicitWidth: labelText.implicitWidth + valueText.implicitWidth + 3 * Theme.spacingNormal
        implicitHeight: Theme.rowHeight

        Text {
            id: labelText

            text: infoRow.label
            color: Theme.mutedText
            width: Theme.labelColumnWidth
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingNormal
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: valueText

            text: infoRow.value
            color: pointer.containsMouse ? Theme.accent : infoRow.valueColor
            width: Math.min(implicitWidth, infoRow.width - Theme.labelColumnWidth - 3 * Theme.spacingNormal)
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingNormal
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: pointer

                anchors.fill: parent
                hoverEnabled: true
                enabled: infoRow.copyable && infoRow.value !== ""

                onClicked: Services.Connectivity.copyAddress()
            }
        }
    }

    Row {
        spacing: Theme.spacingSmall

        IconButton {
            text: "󰈀 Network"
            foreground: root.tab === "network" ? Theme.accent : Theme.mutedText

            onClicked: root.tab = "network"
        }

        IconButton {
            text: "󰂯 Bluetooth"
            foreground: root.tab === "bluetooth" ? Theme.accent : Theme.mutedText

            onClicked: root.tab = "bluetooth"
        }
    }

    Column {
        visible: root.tab === "network"
        width: root.contentWidth
        spacing: Theme.spacingNormal

        SectionHeader {
            text: "Ethernet"
        }

        InfoRow {
            label: "State"
            value: root.linkState()
            valueColor: root.linkColor()
            width: parent.width
        }

        InfoRow {
            label: "Interface"
            value: root.interfaceLabel()
            width: parent.width
        }

        InfoRow {
            label: "IPv4"
            value: Services.Connectivity.address !== "" ? Services.Connectivity.address : "--"
            copyable: true
            width: parent.width
        }

        InfoRow {
            label: "Gateway"
            value: Services.Connectivity.gateway !== "" ? Services.Connectivity.gateway : "--"
            width: parent.width
        }

        InfoRow {
            label: "DNS"
            value: Services.Connectivity.dnsServers.length > 0 ? Services.Connectivity.dnsServers.join(", ") : "--"
            width: parent.width
        }

        SectionHeader {
            text: "Traffic"
        }

        InfoRow {
            label: "Rate"
            value: "↓ " + Units.rate(Services.Connectivity.downRate) + "   ↑ " + Units.rate(Services.Connectivity.upRate)
            width: parent.width
        }

        InfoRow {
            label: "Session"
            value: "↓ " + Units.bytes(Services.Connectivity.sessionDown, 1) + "   ↑ " + Units.bytes(Services.Connectivity.sessionUp, 1)
            width: parent.width
        }

        IconButton {
            text: "󰒓 nm-connection-editor"

            onClicked: {
                Quickshell.execDetached(Config.networkSettings);
                root.bar.closePopout();
            }
        }
    }

    Column {
        visible: root.tab === "bluetooth"
        width: root.contentWidth
        spacing: Theme.spacingNormal

        SectionHeader {
            text: "Adapter"
        }

        InfoRow {
            label: root.adapter !== null ? root.adapter.name : "Adapter"
            value: {
                if (root.adapter === null)
                    return "Unavailable";
                return root.adapter.enabled ? "On" : "Off";
            }
            valueColor: root.adapter !== null && root.adapter.enabled ? Theme.success : Theme.mutedText
            width: parent.width
        }

        IconButton {
            text: root.adapter !== null && root.adapter.discovering ? "󰑐 Stop scan" : "󰑐 Scan"
            interactive: root.adapter !== null && root.adapter.enabled

            onClicked: root.adapter.discovering = !root.adapter.discovering
        }

        SectionHeader {
            visible: root.connectedDevices.length > 0
            text: "Connected"
        }

        Repeater {
            model: root.connectedDevices

            delegate: DeviceRow {
                width: root.contentWidth
            }
        }

        SectionHeader {
            visible: root.pairedDevices.length > 0
            text: "Paired"
        }

        Repeater {
            model: root.pairedDevices

            delegate: DeviceRow {
                width: root.contentWidth
            }
        }

        IconButton {
            text: "󰂯 blueman"

            onClicked: {
                Quickshell.execDetached(Config.bluetoothSettings);
                root.bar.closePopout();
            }
        }
    }
}
