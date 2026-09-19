pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET") ?? ""

    property var workspaces: []
    property var windows: []
    property var casts: []

    function request(action: var): void {
        const socket = requestSocket.createObject(root, {
            payload: JSON.stringify({
                Action: action
            })
        });
        socket.connected = true;
    }

    function castTarget(cast: var): string {
        if ("Window" in cast.target) {
            const id = cast.target.Window.id;
            const window = root.windows.find(w => w.id === id);
            return window !== undefined && window.title ? window.title : "window " + id;
        }
        if ("Output" in cast.target)
            return cast.target.Output.name;
        return "nothing";
    }

    function handleEvent(event: var): void {
        const kind = Object.keys(event)[0];
        const data = event[kind];

        switch (kind) {
        case "WorkspacesChanged":
            root.workspaces = data.workspaces;
            break;
        case "WorkspaceActivated": {
            const activated = root.workspaces.find(ws => ws.id === data.id);
            const output = activated !== undefined ? activated.output : null;
            root.workspaces = root.workspaces.map(ws => Object.assign({}, ws, {
                is_active: ws.output === output ? ws.id === data.id : ws.is_active,
                is_focused: data.focused ? ws.id === data.id : ws.is_focused
            }));
            break;
        }
        case "WorkspaceUrgencyChanged":
            root.workspaces = root.workspaces.map(ws => ws.id === data.id ? Object.assign({}, ws, {
                is_urgent: data.urgent
            }) : ws);
            break;
        case "WorkspaceActiveWindowChanged":
            root.workspaces = root.workspaces.map(ws => ws.id === data.workspace_id ? Object.assign({}, ws, {
                active_window_id: data.active_window_id
            }) : ws);
            break;
        case "WindowsChanged":
            root.windows = data.windows;
            break;
        case "WindowOpenedOrChanged": {
            const others = root.windows.filter(w => w.id !== data.window.id).map(w => data.window.is_focused ? Object.assign({}, w, {
                is_focused: false
            }) : w);
            root.windows = [...others, data.window];
            break;
        }
        case "WindowClosed":
            root.windows = root.windows.filter(w => w.id !== data.id);
            break;
        case "WindowFocusChanged":
            root.windows = root.windows.map(w => Object.assign({}, w, {
                is_focused: w.id === data.id
            }));
            break;
        case "WindowUrgencyChanged":
            root.windows = root.windows.map(w => w.id === data.id ? Object.assign({}, w, {
                is_urgent: data.urgent
            }) : w);
            break;
        case "CastsChanged":
            root.casts = data.casts;
            break;
        case "CastStartedOrChanged":
            root.casts = [...root.casts.filter(c => c.stream_id !== data.cast.stream_id), data.cast];
            break;
        case "CastStopped":
            root.casts = root.casts.filter(c => c.stream_id !== data.stream_id);
            break;
        }
    }

    Socket {
        id: events

        path: root.socketPath
        connected: true

        parser: SplitParser {
            onRead: data => {
                const line = data.trim();
                if (line === "")
                    return;

                const parsed = JSON.parse(line);
                if ("Ok" in parsed)
                    return;
                if ("Err" in parsed) {
                    console.warn("niri event stream refused:", parsed.Err);
                    return;
                }
                root.handleEvent(parsed);
            }
        }

        onConnectionStateChanged: {
            if (events.connected) {
                events.write("\"EventStream\"\n");
                events.flush();
            } else {
                retryTimer.restart();
            }
        }

        onError: retryTimer.restart()
    }

    Timer {
        id: retryTimer

        interval: 5000

        onTriggered: events.connected = true
    }

    Component {
        id: requestSocket

        Socket {
            id: socket

            required property string payload

            path: root.socketPath

            parser: SplitParser {
                onRead: data => {
                    const parsed = JSON.parse(data.trim());
                    if ("Err" in parsed)
                        console.warn("niri request failed:", parsed.Err);
                    socket.destroy();
                }
            }

            onConnectionStateChanged: {
                if (socket.connected) {
                    socket.write(socket.payload + "\n");
                    socket.flush();
                }
            }

            onError: error => {
                console.warn("niri request socket error:", error);
                socket.destroy();
            }
        }
    }
}
