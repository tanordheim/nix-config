pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property string status: "idle"
    property bool failed: false

    function toggle(): void {
        Quickshell.execDetached(Config.voxtypeToggle);
    }

    function retry(): void {
        root.failed = false;
        stream.running = true;
    }

    Process {
        id: stream

        command: Config.voxtypeStatus
        running: true

        stdout: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (line === "")
                    return;

                const parsed = JSON.parse(line);
                root.status = parsed.class ?? "idle";
                root.failed = false;
            }
        }

        onExited: {
            root.failed = true;
            root.status = "idle";
            retryTimer.start();
        }
    }

    Timer {
        id: retryTimer

        interval: 5000

        onTriggered: stream.running = true
    }
}
