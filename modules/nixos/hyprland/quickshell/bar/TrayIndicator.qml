import QtQml.Models
import QtQuick
import Quickshell.Services.SystemTray
import qs.popouts
import qs.theme

Item {
    id: root

    required property var bar

    property int revision: 0

    readonly property bool attention: (root.revision, SystemTray.items.values.some(item => item.status === Status.NeedsAttention))

    visible: SystemTray.items.values.length > 0
    implicitWidth: glyph.implicitWidth
    implicitHeight: glyph.implicitHeight

    Text {
        id: glyph

        anchors.fill: parent
        text: "󰇙"
        color: Theme.mutedText
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText
    }

    Rectangle {
        visible: root.attention
        width: Theme.dotSize
        height: width
        radius: width / 2
        color: Theme.warning
        anchors.top: glyph.top
        anchors.right: glyph.right
        anchors.rightMargin: -Theme.spacingSmall
    }

    Instantiator {
        model: SystemTray.items

        Connections {
            target: modelData

            function onStatusChanged(): void {
                root.revision++;
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.bar.togglePopout("tray")
    }

    TrayPopout {
        bar: root.bar
        source: root
    }
}
