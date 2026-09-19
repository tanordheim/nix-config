import QtQuick
import qs.theme

Text {
    id: root

    required property string output

    property real maxWidth: 0
    property var trackedId: null

    readonly property var tracked: root.trackedId !== null ? (Niri.windows.find(w => w.id === root.trackedId) ?? null) : null
    readonly property var trackedWorkspace: root.tracked !== null ? (Niri.workspaces.find(ws => ws.id === root.tracked.workspace_id) ?? null) : null
    readonly property bool onActiveWorkspace: root.trackedWorkspace !== null && root.trackedWorkspace.output === root.output && root.trackedWorkspace.is_active

    text: root.onActiveWorkspace ? (root.tracked.title ?? "") : ""
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    textFormat: Text.PlainText
    elide: Text.ElideRight
    width: Math.min(implicitWidth, root.maxWidth)

    function track(): void {
        const focused = Niri.windows.find(w => w.is_focused);
        if (focused === undefined)
            return;

        const workspace = Niri.workspaces.find(ws => ws.id === focused.workspace_id);
        if (workspace !== undefined && workspace.output === root.output)
            root.trackedId = focused.id;
    }

    Component.onCompleted: root.track()

    Connections {
        target: Niri

        function onWindowsChanged(): void {
            root.track();
        }
    }
}
