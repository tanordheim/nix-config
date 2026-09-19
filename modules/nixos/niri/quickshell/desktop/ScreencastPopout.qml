import QtQuick
import qs.components
import qs.theme

Popout {
    id: root

    name: "screencast"

    function describe(cast: var): string {
        const parts = [cast.kind === "PipeWire" ? "PipeWire" : "wlr-screencopy"];
        if (cast.is_dynamic_target)
            parts.push("dynamic target");
        if (!cast.is_active)
            parts.push("paused");
        return parts.join(" · ");
    }

    SectionHeader {
        text: "Screencasts"
    }

    Repeater {
        model: Niri.casts

        delegate: ListRow {
            id: entry

            required property var modelData

            interactive: false
            width: root.contentWidth

            Rectangle {
                width: Theme.dotSize
                height: Theme.dotSize
                radius: Theme.dotSize / 2
                color: entry.modelData.is_active ? Theme.critical : Theme.warning

                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: Niri.castTarget(entry.modelData)
                    color: Theme.text
                    width: Theme.textColumnWidth
                    elide: Text.ElideRight
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText
                }

                Text {
                    text: root.describe(entry.modelData)
                    color: Theme.mutedText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
