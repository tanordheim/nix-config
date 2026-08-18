import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.theme

PopupWindow {
    id: root

    required property var bar
    required property Item source
    required property string name

    property alias contentWidth: layout.width

    default property alias content: layout.data

    visible: root.bar.popout === root.name && root.source.visible
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

    onVisibleChanged: {
        if (!root.visible && root.bar.popout === root.name)
            root.bar.closePopout();
    }

    HyprlandFocusGrab {
        active: root.visible
        windows: [root, root.bar]

        onCleared: root.bar.closePopout()
    }

    PopoutSurface {
        id: surface

        anchors.fill: parent
        implicitWidth: Math.max(Theme.popoutMinWidth, layout.implicitWidth + 2 * Theme.popoutPadding)
        implicitHeight: layout.implicitHeight + 2 * Theme.popoutPadding
        opacity: root.visible ? 1 : 0
        focus: true

        Keys.onEscapePressed: root.bar.closePopout()

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.animationFast
                easing.type: Easing.OutCubic
            }
        }

        Column {
            id: layout

            anchors.fill: parent
            anchors.margins: Theme.popoutPadding
            spacing: Theme.spacingNormal
        }
    }
}
