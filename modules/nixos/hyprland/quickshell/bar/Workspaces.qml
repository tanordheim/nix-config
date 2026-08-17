import QtQuick
import Quickshell.Hyprland
import qs.theme

Item {
    id: root

    required property HyprlandMonitor monitor

    readonly property var monitorWorkspaces: Hyprland.workspaces.values.filter(ws => ws.id >= 0 && ws.monitor === root.monitor).sort((a, b) => a.id - b.id)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function step(delta: int): void {
        const list = root.monitorWorkspaces;
        if (list.length === 0)
            return;

        const current = list.findIndex(ws => ws.active);
        const target = current === -1 ? 0 : Math.max(0, Math.min(list.length - 1, current + delta));
        list[target].activate();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton

        onWheel: wheel => {
            const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;
            if (delta !== 0)
                root.step(delta > 0 ? -1 : 1);
            wheel.accepted = true;
        }
    }

    Row {
        id: row

        anchors.centerIn: parent
        spacing: Theme.spacingSmall

        Repeater {
            model: root.monitorWorkspaces

            delegate: Item {
                id: bullet

                required property HyprlandWorkspace modelData

                readonly property bool occupied: bullet.modelData.toplevels.values.length > 0

                implicitWidth: Theme.bulletSlot
                implicitHeight: Theme.bulletSlot

                Rectangle {
                    id: dot

                    anchors.centerIn: parent
                    width: bullet.modelData.active ? Theme.bulletActiveSize : Theme.bulletSize
                    height: width
                    radius: width / 2
                    color: {
                        if (bullet.modelData.urgent)
                            return Theme.critical;
                        if (bullet.modelData.active)
                            return Theme.accent;
                        if (bullet.occupied)
                            return Theme.text;
                        return Theme.separator;
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: Theme.animationFast
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.animationFast
                        }
                    }

                    SequentialAnimation on opacity {
                        running: bullet.modelData.urgent
                        loops: Animation.Infinite
                        alwaysRunToEnd: true

                        NumberAnimation {
                            to: Theme.dimOpacity
                            duration: Theme.animationSlow
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            to: 1.0
                            duration: Theme.animationSlow
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: bullet.modelData.activate()
                }
            }
        }
    }
}
