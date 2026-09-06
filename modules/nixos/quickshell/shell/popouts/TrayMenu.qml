import QtQuick
import Quickshell
import qs.components
import qs.theme

Column {
    id: root

    required property var rootMenu
    required property real rowWidth

    property var stack: []

    readonly property var currentMenu: root.stack.length > 0 ? root.stack[root.stack.length - 1] : root.rootMenu

    spacing: 0

    function reset(): void {
        root.stack = [];
    }

    function enter(entry: var): void {
        root.stack = root.stack.concat([entry]);
    }

    function back(): void {
        root.stack = root.stack.slice(0, root.stack.length - 1);
    }

    onRootMenuChanged: root.reset()

    QsMenuOpener {
        id: opener

        menu: root.currentMenu
    }

    ListRow {
        visible: root.stack.length > 0
        width: root.rowWidth

        onClicked: root.back()

        Text {
            text: "󰅁 back"
            color: Theme.mutedText
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Repeater {
        model: opener.children

        delegate: Item {
            id: entry

            required property QsMenuEntry modelData

            implicitWidth: row.implicitWidth
            implicitHeight: entry.modelData.isSeparator ? Theme.spacingNormal : row.implicitHeight

            Rectangle {
                visible: entry.modelData.isSeparator
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 1
                color: Theme.separator
            }

            ListRow {
                id: row

                visible: !entry.modelData.isSeparator
                width: root.rowWidth
                interactive: entry.modelData.enabled

                onClicked: {
                    if (entry.modelData.hasChildren)
                        root.enter(entry.modelData);
                    else
                        entry.modelData.triggered();
                }

                Text {
                    text: {
                        if (entry.modelData.checkState === Qt.Checked)
                            return "󰄬";
                        return " ";
                    }
                    visible: entry.modelData.buttonType !== QsMenuButtonType.None
                    color: Theme.accent
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: entry.modelData.text
                    color: entry.modelData.enabled ? Theme.text : Theme.separator
                    width: Math.min(implicitWidth, Theme.textColumnWidth)
                    elide: Text.ElideRight
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    visible: entry.modelData.hasChildren
                    text: "󰅂"
                    color: Theme.mutedText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText

                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
