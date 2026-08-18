pragma Singleton

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer active: null
    property real position: 0

    readonly property string icon: {
        DesktopEntries.applications.values;

        if (root.active === null)
            return "";

        const entry = root.active.desktopEntry !== "" ? DesktopEntries.heuristicLookup(root.active.desktopEntry) : null;
        if (entry === null || entry.icon === "")
            return "";
        return Quickshell.iconPath(entry.icon, true);
    }

    readonly property real length: root.active !== null && root.active.lengthSupported ? root.active.length : -1
    readonly property bool timeAvailable: root.active !== null && root.active.positionSupported && root.length > 0

    onActiveChanged: root.position = root.active !== null ? root.active.position : 0

    function reselect(): void {
        const players = Mpris.players.values.filter(player => player.identity !== "playerctld");

        if (root.active !== null && !players.includes(root.active))
            root.active = null;
        if (root.active !== null && root.active.isPlaying)
            return;

        const playing = players.find(player => player.isPlaying);
        if (playing !== undefined) {
            root.active = playing;
            return;
        }

        if (root.active !== null)
            return;

        root.active = players.find(player => player.playbackState === MprisPlaybackState.Paused) ?? players.find(player => player.canControl) ?? null;
    }

    Component.onCompleted: root.reselect()

    Connections {
        target: Mpris.players

        function onValuesChanged(): void {
            root.reselect();
        }
    }

    Instantiator {
        model: Mpris.players

        Connections {
            target: modelData

            function onIsPlayingChanged(): void {
                root.reselect();
            }
        }
    }

    Timer {
        interval: 1000
        running: root.active !== null
        repeat: true
        triggeredOnStart: true

        onTriggered: root.position = root.active !== null ? root.active.position : 0
    }
}
