import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.theme

PanelWindow {
    id: root

    required property var modelData

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.modelData)
    readonly property real sideWidth: Math.max(workspaces.width, clock.width)

    screen: root.modelData
    color: Theme.background
    implicitHeight: Theme.barHeight

    anchors {
        top: true
        left: true
        right: true
    }

    Workspaces {
        id: workspaces

        monitor: root.monitor

        anchors.left: parent.left
        anchors.leftMargin: Theme.spacingLarge
        anchors.verticalCenter: parent.verticalCenter
    }

    WindowTitle {
        monitor: root.monitor
        maxWidth: Math.max(0, root.width - 2 * (root.sideWidth + 2 * Theme.spacingLarge))

        anchors.centerIn: parent
    }

    Clock {
        id: clock

        anchors.right: parent.right
        anchors.rightMargin: Theme.spacingLarge
        anchors.verticalCenter: parent.verticalCenter
    }
}
