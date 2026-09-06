import QtQuick
import Quickshell.Hyprland
import qs.theme

Text {
    id: root

    required property HyprlandMonitor monitor

    property real maxWidth: 0
    property HyprlandToplevel tracked: null

    readonly property bool onActiveWorkspace: root.tracked !== null && root.monitor !== null && root.tracked.workspace === root.monitor.activeWorkspace

    text: root.onActiveWorkspace ? root.tracked.title : ""
    color: Theme.text
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    textFormat: Text.PlainText
    elide: Text.ElideRight
    width: Math.min(implicitWidth, root.maxWidth)

    function track(): void {
        const active = Hyprland.activeToplevel;
        if (active !== null && active.monitor === root.monitor)
            root.tracked = active;
    }

    Component.onCompleted: root.track()

    Connections {
        target: Hyprland

        function onActiveToplevelChanged(): void {
            root.track();
        }
    }
}
