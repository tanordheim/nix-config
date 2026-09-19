import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.components
import qs.theme

PopupWindow {
    id: root

    required property var bar

    property Item source: null
    property var workspaceId: null

    readonly property real contentWidth: Theme.popoutWidth
    readonly property var windows: root.workspaceId !== null ? Niri.windows.filter(w => w.workspace_id === root.workspaceId) : []
    readonly property bool pointerInside: pointer.hovered

    signal activated

    visible: root.source !== null && root.windows.length > 0 && root.bar.popout === ""
    color: "transparent"
    implicitWidth: surface.implicitWidth
    implicitHeight: surface.implicitHeight

    anchor {
        window: root.bar
        edges: Edges.Bottom
        gravity: Edges.Bottom
        adjustment: PopupAdjustment.SlideX

        onAnchoring: {
            const center = root.source.mapToItem(root.bar.contentItem, root.source.width / 2, 0);
            root.anchor.rect = Qt.rect(center.x, root.bar.height + Theme.popoutGap, 1, 1);
        }
    }

    function iconFor(appId: string): string {
        DesktopEntries.applications.values;

        if (appId === "")
            return "";

        const entry = DesktopEntries.heuristicLookup(appId);
        if (entry === null || entry.icon === "")
            return "";

        return Quickshell.iconPath(entry.icon, true);
    }

    onSourceChanged: {
        if (root.source !== null)
            root.anchor.updateAnchor();
    }

    PopoutSurface {
        id: surface

        anchors.fill: parent
        implicitWidth: root.contentWidth + 2 * Theme.popoutPadding
        implicitHeight: layout.implicitHeight + 2 * Theme.popoutPadding
        opacity: root.visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animationFast
                easing.type: Easing.OutCubic
            }
        }

        HoverHandler {
            id: pointer
        }

        Column {
            id: layout

            anchors.fill: parent
            anchors.margins: Theme.popoutPadding
            spacing: Theme.spacingSmall

            Repeater {
                model: root.windows

                delegate: ListRow {
                    id: entry

                    required property var modelData

                    readonly property string iconSource: root.iconFor(entry.modelData.app_id ?? "")

                    width: root.contentWidth

                    onClicked: {
                        Niri.request({
                            FocusWindow: {
                                id: entry.modelData.id
                            }
                        });
                        root.activated();
                    }

                    IconImage {
                        visible: entry.iconSource !== ""
                        source: entry.iconSource
                        implicitSize: Theme.iconSize

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: entry.iconSource === ""
                        text: "󰖯"
                        color: Theme.text
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        textFormat: Text.PlainText

                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: entry.modelData.title ?? ""
                        color: entry.modelData.is_focused ? Theme.accent : Theme.text
                        width: Math.min(implicitWidth, Theme.textColumnWidth)
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        textFormat: Text.PlainText

                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
