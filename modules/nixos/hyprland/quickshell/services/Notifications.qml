pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property int count: 0
    property bool dnd: false
    property bool failed: false

    readonly property bool hasNotifications: root.count > 0

    function toggleCenter(): void {
        Quickshell.execDetached(Config.swayncToggleCenter);
    }

    function toggleDnd(): void {
        Quickshell.execDetached(Config.swayncToggleDnd);
    }

    Process {
        id: stream

        command: Config.swayncStream
        running: true

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (line === "")
                    return;

                const parsed = JSON.parse(line);
                root.count = parseInt(parsed.text) || 0;
                root.dnd = String(parsed.class ?? "").includes("dnd");
                root.failed = false;
            }
        }

        onExited: {
            root.failed = true;
            retryTimer.start();
        }
    }

    Timer {
        id: retryTimer

        interval: 5000

        onTriggered: stream.running = true
    }
}
