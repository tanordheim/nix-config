import QtQuick
import Quickshell
import qs.config
import qs.services as Services
import qs.theme

PanelWindow {
    id: root

    required property var modelData

    property string popout: ""
    property Component workspaceContent: null
    property Component titleContent: null
    property Component indicatorContent: null

    readonly property bool primary: root.modelData.name === Config.primaryMonitor
    readonly property real sideWidth: Math.max(leftRow.width, rightRow.width)

    screen: root.modelData
    color: Theme.background
    implicitHeight: Theme.barHeight

    anchors {
        top: true
        left: true
        right: true
    }

    function togglePopout(name: string): void {
        root.popout = root.popout === name ? "" : name;
    }

    function closePopout(): void {
        root.popout = "";
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: root.closePopout()
    }

    component Separator: Rectangle {
        implicitWidth: 1
        implicitHeight: Theme.fontSize
        color: Theme.separator

        anchors.verticalCenter: parent.verticalCenter
    }

    Row {
        id: leftRow

        height: parent.height
        spacing: Theme.spacingLarge

        anchors.left: parent.left
        anchors.leftMargin: Theme.spacingLarge

        Loader {
            sourceComponent: root.workspaceContent

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {
            visible: root.workspaceContent !== null && voiceType.visible
        }

        VoiceType {
            id: voiceType

            visible: root.primary

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {
            visible: mediaIndicator.visible
        }

        MediaIndicator {
            id: mediaIndicator

            bar: root
            visible: root.primary && Services.Media.active !== null

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {
            visible: indicator.visible
        }

        Loader {
            id: indicator

            sourceComponent: root.indicatorContent
            visible: indicator.item !== null && indicator.item.visible

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Loader {
        sourceComponent: root.titleContent

        anchors.centerIn: parent
    }

    Row {
        id: rightRow

        height: parent.height
        spacing: Theme.spacingLarge

        anchors.right: parent.right
        anchors.rightMargin: Theme.spacingLarge

        TelemetryIndicator {
            bar: root
            visible: root.primary

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {
            visible: root.primary
        }

        StatusArea {
            visible: root.primary
            bar: root

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {
            visible: root.primary
        }

        Clock {
            bar: root

            anchors.verticalCenter: parent.verticalCenter
        }

        Separator {}

        SessionControl {
            bar: root

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
