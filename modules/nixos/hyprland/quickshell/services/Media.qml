pragma Singleton

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer active: null

    readonly property string icon: {
        if (root.active === null)
            return "";

        const entry = root.active.desktopEntry !== "" ? DesktopEntries.heuristicLookup(root.active.desktopEntry) : null;
        const name = entry !== null && entry.icon !== "" ? entry.icon : "audio-x-generic";
        return Quickshell.iconPath(name, "audio-x-generic");
    }

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
}
