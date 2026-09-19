import QtQuick
import qs.theme

Item {
    id: root

    required property var bar

    readonly property bool anyActive: Niri.casts.some(c => c.is_active)

    visible: Niri.casts.length > 0
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row

        spacing: Theme.spacingSmall

        Text {
            id: icon

            text: "󰄘"
            color: root.anyActive ? Theme.critical : Theme.warning
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animationFast
                }
            }

            SequentialAnimation on opacity {
                running: root.anyActive
                loops: Animation.Infinite
                alwaysRunToEnd: true

                NumberAnimation {
                    to: Theme.dimOpacity
                    duration: Theme.animationSlow
                    easing.type: Easing.InOutQuad
                }

                NumberAnimation {
                    to: 1.0
                    duration: Theme.animationSlow
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Text {
            text: Niri.casts.length === 1 ? Niri.castTarget(Niri.casts[0]) : Niri.casts.length + " casts"
            color: Theme.mutedText
            width: Math.min(implicitWidth, Theme.textColumnWidth)
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.bar.togglePopout("screencast")
    }

    ScreencastPopout {
        bar: root.bar
        source: root
    }
}
