import Quickshell
import qs.components
import qs.config

Popout {
    id: root

    name: "session"
    contentWidth: 140

    IconButton {
        width: root.contentWidth
        text: "󰍃 Logout"

        onClicked: {
            root.bar.closePopout();
            Quickshell.execDetached(Config.logoutSession);
        }
    }

    IconButton {
        width: root.contentWidth
        text: "󰜉 Reboot"

        onClicked: {
            root.bar.closePopout();
            Quickshell.execDetached(Config.rebootSystem);
        }
    }
}
