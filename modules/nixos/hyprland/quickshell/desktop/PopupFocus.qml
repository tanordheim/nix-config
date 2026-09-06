import Quickshell.Hyprland

HyprlandFocusGrab {
    id: root

    required property var popup

    active: root.popup.backingWindowVisible
    windows: [root.popup, root.popup.bar]

    onCleared: root.popup.bar.closePopout()
}
