pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property int cpuPercent: -1
    property int gpuPercent: -1
    property int memPercent: -1
    property real cpuTemp: -1
    property real gpuTemp: -1

    readonly property int cpuTempWarning: 75
    readonly property int cpuTempCritical: 85
    readonly property int gpuTempWarning: 85
    readonly property int gpuTempCritical: 95

    readonly property string testCpuTemp: Quickshell.env("QS_TEST_CPU_TEMP") ?? ""
    readonly property string testGpuTemp: Quickshell.env("QS_TEST_GPU_TEMP") ?? ""
    readonly property real effectiveCpuTemp: root.testCpuTemp !== "" ? Number(root.testCpuTemp) : root.cpuTemp
    readonly property real effectiveGpuTemp: root.testGpuTemp !== "" ? Number(root.testGpuTemp) : root.gpuTemp

    readonly property string cpuLevel: root.level(root.effectiveCpuTemp, root.cpuTempWarning, root.cpuTempCritical)
    readonly property string gpuLevel: root.level(root.effectiveGpuTemp, root.gpuTempWarning, root.gpuTempCritical)

    property double prevCpuIdle: 0
    property double prevCpuTotal: -1
    property string cpuTempPath: ""
    property string gpuTempPath: ""
    property bool readFailed: false

    function level(temp: real, warning: int, critical: int): string {
        if (temp < 0)
            return "normal";
        if (temp >= critical)
            return "critical";
        if (temp >= warning)
            return "warning";
        return "normal";
    }

    function readFile(view): var {
        root.readFailed = false;
        view.reload();
        return root.readFailed ? null : view.text();
    }

    function sampleCpu(text: string): void {
        const parts = text.split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
        if (parts.length < 5 || parts.some(isNaN)) {
            root.cpuPercent = -1;
            root.prevCpuTotal = -1;
            return;
        }

        const idle = parts[3] + parts[4];
        const total = parts.reduce((a, b) => a + b, 0);
        if (root.prevCpuTotal >= 0 && total > root.prevCpuTotal) {
            const deltaTotal = total - root.prevCpuTotal;
            root.cpuPercent = Math.round(100 * (deltaTotal - (idle - root.prevCpuIdle)) / deltaTotal);
        }
        root.prevCpuIdle = idle;
        root.prevCpuTotal = total;
    }

    function memField(text: string, name: string): real {
        const match = text.match(new RegExp("^" + name + ":\\s+(\\d+)", "m"));
        return match === null ? -1 : Number(match[1]);
    }

    function parseMem(text: string): int {
        const total = root.memField(text, "MemTotal");
        const available = root.memField(text, "MemAvailable");
        if (total <= 0 || available < 0)
            return -1;
        return Math.round(100 * (total - available) / total);
    }

    function parsePercent(text: string): int {
        const value = parseInt(text);
        return isNaN(value) ? -1 : value;
    }

    function pollTemp(view, path: string): real {
        if (path === "")
            return -1;
        const text = root.readFile(view);
        if (text === null)
            return -1;
        const value = parseInt(text);
        return isNaN(value) ? -1 : value / 1000;
    }

    function globResult(line): string {
        const path = (line ?? "").trim().split(/\s+/)[0] ?? "";
        return path.includes("*") ? "" : path;
    }

    FileView {
        id: statFile

        path: "/proc/stat"
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: memFile

        path: "/proc/meminfo"
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: gpuBusyFile

        path: Config.gpuBusyPath
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: cpuTempFile

        path: root.cpuTempPath
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: gpuTempFile

        path: root.gpuTempPath
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    Process {
        id: resolver

        command: [Config.shell, "-c", "echo " + Config.cpuTempGlob + "\necho " + Config.gpuTempGlob]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                root.cpuTempPath = root.globResult(lines[0]);
                root.gpuTempPath = root.globResult(lines[1]);
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            const stat = root.readFile(statFile);
            if (stat === null) {
                root.cpuPercent = -1;
                root.prevCpuTotal = -1;
            } else {
                root.sampleCpu(stat);
            }

            const mem = root.readFile(memFile);
            root.memPercent = mem === null ? -1 : root.parseMem(mem);

            const busy = root.readFile(gpuBusyFile);
            root.gpuPercent = busy === null ? -1 : root.parsePercent(busy);
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.cpuTemp = root.pollTemp(cpuTempFile, root.cpuTempPath);
            if (root.readFailed)
                root.cpuTempPath = "";

            root.gpuTemp = root.pollTemp(gpuTempFile, root.gpuTempPath);
            if (root.readFailed)
                root.gpuTempPath = "";

            if ((root.cpuTempPath === "" || root.gpuTempPath === "") && !resolver.running)
                resolver.running = true;
        }
    }
}
