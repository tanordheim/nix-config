import QtQuick
import Quickshell.Services.Pipewire
import qs.theme

Item {
    id: root

    required property PwNode node

    readonly property PwNodeAudio audio: root.node !== null ? root.node.audio : null
    readonly property bool available: root.audio !== null && root.node.ready
    readonly property real level: root.available ? Math.max(0, Math.min(1, root.audio.volume)) : 0

    implicitWidth: Theme.sliderWidth
    implicitHeight: Theme.rowHeight

    function setLevel(level: real): void {
        if (!root.available)
            return;
        root.audio.volume = Math.max(0, Math.min(1, level));
    }

    Rectangle {
        id: track

        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: Theme.sliderHeight
        radius: height / 2
        color: Theme.hoverSurface

        Rectangle {
            width: track.width * root.level
            height: parent.height
            radius: parent.radius
            color: root.available && root.audio.muted ? Theme.separator : Theme.accent
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.available

        onPressed: mouse => root.setLevel(mouse.x / root.width)

        onPositionChanged: mouse => {
            if (pressed)
                root.setLevel(mouse.x / root.width);
        }

        onWheel: wheel => {
            const delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;
            if (delta !== 0)
                root.setLevel(root.level + (delta > 0 ? 0.05 : -0.05));
            wheel.accepted = true;
        }
    }
}
