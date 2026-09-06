import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.components
import qs.theme

Popout {
    id: root

    property SystemTrayItem menuItem: null

    name: "tray"

    onVisibleChanged: {
        if (!root.visible)
            root.menuItem = null;
    }

    SectionHeader {
        text: "Tray"
    }

    Repeater {
        model: SystemTray.items

        delegate: Column {
            id: entry

            required property SystemTrayItem modelData

            readonly property bool expanded: root.menuItem === entry.modelData

            spacing: 0

            function openMenu(): void {
                if (entry.modelData.hasMenu)
                    root.menuItem = entry.expanded ? null : entry.modelData;
            }

            ListRow {
                width: root.contentWidth
                selected: entry.expanded

                onClicked: button => {
                    if (button === Qt.MiddleButton) {
                        entry.modelData.secondaryActivate();
                        return;
                    }

                    if (button === Qt.LeftButton && !entry.modelData.onlyMenu) {
                        entry.modelData.activate();
                        root.bar.closePopout();
                        return;
                    }

                    entry.openMenu();
                }

                IconImage {
                    source: entry.modelData.icon
                    implicitSize: Theme.iconSizeLarge

                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: entry.modelData.title !== "" ? entry.modelData.title : entry.modelData.id
                        color: Theme.text
                        width: Math.min(implicitWidth, Theme.textColumnWidth)
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        textFormat: Text.PlainText
                    }

                    Text {
                        visible: text !== ""
                        text: entry.modelData.tooltipDescription !== "" ? entry.modelData.tooltipDescription : entry.modelData.tooltipTitle
                        color: Theme.mutedText
                        width: Math.min(implicitWidth, Theme.textColumnWidth)
                        elide: Text.ElideRight
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSmall
                        textFormat: Text.PlainText
                    }
                }

                Text {
                    visible: entry.modelData.hasMenu
                    text: entry.expanded ? "󰅃" : "󰅀"
                    color: Theme.mutedText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText

                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            TrayMenu {
                visible: entry.expanded
                rootMenu: entry.expanded ? entry.modelData.menu : null
                rowWidth: root.contentWidth
            }
        }
    }
}
