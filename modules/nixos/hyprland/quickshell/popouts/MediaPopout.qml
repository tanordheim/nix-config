import QtQuick
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.components
import qs.services as Services
import qs.theme

Popout {
    id: root

    readonly property MprisPlayer player: Services.Media.active
    readonly property string artUrl: root.player !== null ? root.player.trackArtUrl : ""

    name: "media"

    Row {
        spacing: Theme.spacingNormal

        ClippingRectangle {
            visible: root.artUrl !== ""
            implicitWidth: Theme.artworkSize
            implicitHeight: Theme.artworkSize
            radius: Theme.radius
            color: Theme.hoverSurface

            Image {
                anchors.fill: parent
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize.width: Theme.artworkSize
                sourceSize.height: Theme.artworkSize
            }
        }

        Column {
            spacing: Theme.spacingSmall

            Row {
                spacing: Theme.spacingSmall

                IconImage {
                    visible: Services.Media.icon !== ""
                    source: Services.Media.icon
                    implicitSize: Theme.iconSize

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: root.player !== null ? root.player.identity : ""
                    color: Theme.mutedText
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSmall
                    textFormat: Text.PlainText

                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                text: root.player !== null && root.player.trackTitle !== "" ? root.player.trackTitle : "Unknown track"
                color: Theme.text
                width: Theme.textColumnWidth
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                textFormat: Text.PlainText
            }

            Text {
                visible: text !== ""
                text: root.player !== null ? root.player.trackArtist : ""
                color: Theme.mutedText
                width: Theme.textColumnWidth
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.PlainText
            }

            Row {
                spacing: Theme.spacingSmall

                IconButton {
                    text: "󰒮"
                    interactive: root.player !== null && root.player.canGoPrevious

                    onClicked: root.player.previous()
                }

                IconButton {
                    text: root.player !== null && root.player.isPlaying ? "󰏤" : "󰐊"
                    interactive: root.player !== null && root.player.canTogglePlaying

                    onClicked: root.player.togglePlaying()
                }

                IconButton {
                    text: "󰒭"
                    interactive: root.player !== null && root.player.canGoNext

                    onClicked: root.player.next()
                }
            }
        }
    }
}
