import QtQuick
import Quickshell
import qs.bar
import qs.desktop
import qs.theme

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            id: desktopBar

            workspaceContent: Component {
                Workspaces {
                    bar: desktopBar
                    output: desktopBar.modelData.name
                }
            }

            titleContent: Component {
                WindowTitle {
                    output: desktopBar.modelData.name
                    maxWidth: Math.max(0, desktopBar.width - 2 * (desktopBar.sideWidth + 2 * Theme.spacingLarge))
                }
            }

            indicatorContent: Component {
                ScreencastIndicator {
                    bar: desktopBar
                }
            }
        }
    }
}
