pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    property PwNode sink: null
    property PwNode source: null

    readonly property PwNode defaultSink: Pipewire.defaultAudioSink
    readonly property PwNode defaultSource: Pipewire.defaultAudioSource
    readonly property var sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && node.audio !== null)

    readonly property PwNodeAudio sinkAudio: root.sink !== null ? root.sink.audio : null
    readonly property bool sinkAvailable: root.sinkAudio !== null && root.sink.ready
    readonly property int sinkPercent: root.sinkAvailable ? Math.round(root.sinkAudio.volume * 100) : -1
    readonly property bool sinkMuted: root.sinkAvailable && root.sinkAudio.muted

    onDefaultSinkChanged: {
        if (root.defaultSink !== null)
            root.sink = root.defaultSink;
    }

    onDefaultSourceChanged: {
        if (root.defaultSource !== null)
            root.source = root.defaultSource;
    }

    function nodeLabel(node: PwNode): string {
        if (node === null)
            return "";
        return node.description !== "" ? node.description : (node.nickname !== "" ? node.nickname : node.name);
    }

    function selectSink(node: PwNode): void {
        Pipewire.preferredDefaultAudioSink = node;
    }

    function adjustSink(step: real): void {
        if (!root.sinkAvailable)
            return;
        root.sinkAudio.volume = Math.max(0, Math.min(1, root.sinkAudio.volume + step));
    }

    function toggleSinkMute(): void {
        if (root.sinkAvailable)
            root.sinkAudio.muted = !root.sinkAudio.muted;
    }

    function toggleSourceMute(): void {
        if (root.source !== null && root.source.audio !== null)
            root.source.audio.muted = !root.source.audio.muted;
    }

    Component.onCompleted: {
        root.sink = Pipewire.defaultAudioSink;
        root.source = Pipewire.defaultAudioSource;
    }

    PwObjectTracker {
        objects: {
            const tracked = root.sinks.slice();
            if (root.sink !== null && !tracked.includes(root.sink))
                tracked.push(root.sink);
            if (root.source !== null)
                tracked.push(root.source);
            return tracked;
        }
    }
}
