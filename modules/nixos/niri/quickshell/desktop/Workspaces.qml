import QtQuick
import qs.theme

Item {
    id: root

    required property string output
    required property var bar

    property var pendingWorkspaceId: null
    property Item pendingSource: null

    readonly property var outputWorkspaces: Niri.workspaces.filter(ws => ws.output === root.output).sort((a, b) => a.idx - b.idx)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    function focusWorkspace(id: var): void {
        Niri.request({
            FocusWorkspace: {
                reference: {
                    Id: id
                }
            }
        });
    }

    function step(delta: int): void {
        const list = root.outputWorkspaces;
        if (list.length === 0)
            return;

        const current = list.findIndex(ws => ws.is_active);
        const target = current === -1 ? 0 : Math.max(0, Math.min(list.length - 1, current + delta));
        root.focusWorkspace(list[target].id);
    }

    function requestPreview(workspaceId: var, source: Item): void {
        closeTimer.stop();

        if (!Niri.windows.some(w => w.workspace_id === workspaceId)) {
            root.hidePreview();
            return;
        }

        root.pendingWorkspaceId = workspaceId;
        root.pendingSource = source;

        if (preview.workspaceId !== null)
            root.showPreview();
        else
            openTimer.restart();
    }

    function showPreview(): void {
        preview.source = root.pendingSource;
        preview.workspaceId = root.pendingWorkspaceId;
    }

    function hidePreview(): void {
        openTimer.stop();
        closeTimer.stop();
        preview.workspaceId = null;
        preview.source = null;
    }

    function releasePreview(): void {
        openTimer.stop();
        closeTimer.restart();
    }

    Timer {
        id: openTimer

        interval: Theme.hoverDelay

        onTriggered: root.showPreview()
    }

    Timer {
        id: closeTimer

        interval: Theme.hoverGrace

        onTriggered: {
            if (!preview.pointerInside)
                root.hidePreview();
        }
    }

    WorkspacePreview {
        id: preview

        bar: root.bar

        onActivated: root.hidePreview()

        onPointerInsideChanged: {
            if (preview.pointerInside)
                closeTimer.stop();
            else
                root.releasePreview();
        }
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
            model: root.outputWorkspaces

            delegate: Item {
                id: bullet

                required property var modelData

                readonly property bool occupied: Niri.windows.some(w => w.workspace_id === bullet.modelData.id)

                implicitWidth: Theme.bulletSlot
                implicitHeight: Theme.bulletSlot

                Rectangle {
                    id: dot

                    anchors.centerIn: parent
                    width: bullet.modelData.is_active ? Theme.bulletActiveSize : Theme.bulletSize
                    height: width
                    radius: width / 2
                    color: {
                        if (bullet.modelData.is_urgent)
                            return Theme.critical;
                        if (bullet.modelData.is_active)
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
                        running: bullet.modelData.is_urgent
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
                    hoverEnabled: true

                    onClicked: {
                        root.hidePreview();
                        root.focusWorkspace(bullet.modelData.id);
                    }

                    onEntered: root.requestPreview(bullet.modelData.id, bullet)

                    onExited: root.releasePreview()
                }
            }
        }
    }
}
