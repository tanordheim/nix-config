import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.bar
import qs.desktop
import qs.theme

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            id: desktopBar

            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(desktopBar.modelData)

            workspaceContent: Component {
                Workspaces {
                    bar: desktopBar
                    monitor: desktopBar.monitor
                }
            }

            titleContent: Component {
                WindowTitle {
                    monitor: desktopBar.monitor
                    maxWidth: Math.max(0, desktopBar.width - 2 * (desktopBar.sideWidth + 2 * Theme.spacingLarge))
                }
            }
        }
    }
}
