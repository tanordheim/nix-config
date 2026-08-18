pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    readonly property int historyLength: 60

    property int cpuPercent: -1
    property int gpuPercent: -1
    property int memPercent: -1
    property real memUsedBytes: -1
    property real memTotalBytes: -1
    property real diskUsedBytes: -1
    property real diskTotalBytes: -1

    property var cpuHistory: []
    property var gpuHistory: []
    property var memHistory: []

    property var topProcesses: []
    property bool sortByCpu: true
    property bool dashboardOpen: false

    readonly property real cpuTemp: cpuTempSensor.value
    readonly property real gpuTemp: gpuTempSensor.value
    readonly property real nvmeTemp: nvmeTempSensor.value
    readonly property real dimmTemp: dimmTempSensor.value
    readonly property real cpuFan: cpuFanSensor.value
    readonly property real gpuFan: gpuFanSensor.value
    readonly property real chassisFan1: chassisFanSensor1.value
    readonly property real chassisFan2: chassisFanSensor2.value

    readonly property int cpuTempWarning: 75
    readonly property int cpuTempCritical: 85
    readonly property int gpuTempWarning: 85
    readonly property int gpuTempCritical: 95
    readonly property int nvmeTempWarning: 60
    readonly property int nvmeTempCritical: 70
    readonly property int dimmTempWarning: 65
    readonly property int dimmTempCritical: 75

    readonly property string cpuLevel: root.level(root.cpuTemp, root.cpuTempWarning, root.cpuTempCritical)
    readonly property string gpuLevel: root.level(root.gpuTemp, root.gpuTempWarning, root.gpuTempCritical)
    readonly property string nvmeLevel: root.level(root.nvmeTemp, root.nvmeTempWarning, root.nvmeTempCritical)
    readonly property string dimmLevel: root.level(root.dimmTemp, root.dimmTempWarning, root.dimmTempCritical)

    readonly property var sensors: [cpuTempSensor, gpuTempSensor, nvmeTempSensor, dimmTempSensor, cpuFanSensor, gpuFanSensor, chassisFanSensor1, chassisFanSensor2]

    property string cpuHwmon: ""
    property string gpuHwmon: ""
    property string nctHwmon: ""
    property string nvmeHwmon: ""
    property string dimmHwmon: ""

    property double prevCpuIdle: 0
    property double prevCpuTotal: -1
    property bool readFailed: false
    property bool sensorVanished: false

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

    function parseMem(text: string): void {
        const total = text === null ? -1 : root.memField(text, "MemTotal");
        const available = text === null ? -1 : root.memField(text, "MemAvailable");

        if (total <= 0 || available < 0) {
            root.memPercent = -1;
            root.memUsedBytes = -1;
            root.memTotalBytes = -1;
            return;
        }

        root.memTotalBytes = total * 1024;
        root.memUsedBytes = (total - available) * 1024;
        root.memPercent = Math.round(100 * (total - available) / total);
    }

    function parsePercent(text: string): int {
        const value = parseInt(text);
        return isNaN(value) ? -1 : value;
    }

    function parseDisk(text: string): void {
        const fields = (text.trim().split("\n")[1] ?? "").trim().split(/\s+/).map(Number);
        if (fields.length < 2 || fields.some(isNaN)) {
            root.diskUsedBytes = -1;
            root.diskTotalBytes = -1;
            return;
        }

        root.diskUsedBytes = fields[0];
        root.diskTotalBytes = fields[1];
    }

    function parseProcesses(text: string): var {
        return text.trim().split("\n").map(line => {
            const fields = line.trim().match(/^(\S+)\s+(\S+)\s+(.+)$/);
            if (fields === null)
                return null;

            const cpu = Number(fields[1]);
            const mem = Number(fields[2]);
            if (isNaN(cpu) || isNaN(mem))
                return null;

            return {
                cpu: cpu,
                mem: mem,
                name: fields[3]
            };
        }).filter(entry => entry !== null);
    }

    function pushSample(history: var, value: int): var {
        const next = history.concat(value);
        return next.length > root.historyLength ? next.slice(next.length - root.historyLength) : next;
    }

    function globResult(line): string {
        const path = (line ?? "").trim().split(/\s+/)[0] ?? "";
        return path.includes("*") ? "" : path;
    }

    onSortByCpuChanged: {
        root.topProcesses = [];
        if (root.dashboardOpen)
            topTimer.restart();
    }

    onDashboardOpenChanged: {
        if (!root.dashboardOpen)
            root.topProcesses = [];
    }

    component Sensor: FileView {
        id: sensor

        required property string dir
        required property string file
        property real divisor: 1
        property real value: -1

        readonly property bool available: sensor.value >= 0

        path: sensor.dir === "" ? "" : sensor.dir + "/" + sensor.file
        preload: false
        blockAllReads: true
        printErrors: false

        function sample(): void {
            if (sensor.dir === "") {
                sensor.value = -1;
                return;
            }

            const text = root.readFile(sensor);
            if (text === null) {
                sensor.value = -1;
                root.sensorVanished = true;
                return;
            }

            const parsed = parseInt(text);
            sensor.value = isNaN(parsed) ? -1 : parsed / sensor.divisor;
        }

        onLoadFailed: root.readFailed = true
    }

    Sensor {
        id: cpuTempSensor

        dir: root.cpuHwmon
        file: "temp1_input"
        divisor: 1000
    }

    Sensor {
        id: gpuTempSensor

        dir: root.gpuHwmon
        file: "temp2_input"
        divisor: 1000
    }

    Sensor {
        id: nvmeTempSensor

        dir: root.nvmeHwmon
        file: "temp1_input"
        divisor: 1000
    }

    Sensor {
        id: dimmTempSensor

        dir: root.dimmHwmon
        file: "temp1_input"
        divisor: 1000
    }

    Sensor {
        id: cpuFanSensor

        dir: root.nctHwmon
        file: "fan2_input"
    }

    Sensor {
        id: gpuFanSensor

        dir: root.gpuHwmon
        file: "fan1_input"
    }

    Sensor {
        id: chassisFanSensor1

        dir: root.nctHwmon
        file: "fan1_input"
    }

    Sensor {
        id: chassisFanSensor2

        dir: root.nctHwmon
        file: "fan3_input"
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

    Process {
        id: resolver

        command: [Config.shell, "-c", ["echo " + Config.cpuHwmonGlob, "echo " + Config.gpuHwmonGlob, "echo " + Config.nctHwmonGlob, "echo " + Config.nvmeHwmonGlob, "echo " + Config.dimmHwmonGlob].join("\n")]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n");
                root.cpuHwmon = root.globResult(lines[0]);
                root.gpuHwmon = root.globResult(lines[1]);
                root.nctHwmon = root.globResult(lines[2]);
                root.nvmeHwmon = root.globResult(lines[3]);
                root.dimmHwmon = root.globResult(lines[4]);
            }
        }
    }

    Process {
        id: diskProcess

        command: Config.diskUsage

        stdout: StdioCollector {
            onStreamFinished: root.parseDisk(this.text)
        }
    }

    Process {
        id: topProcess

        command: root.sortByCpu ? Config.topProcessesByCpu : Config.topProcessesByMemory

        stdout: StdioCollector {
            onStreamFinished: root.topProcesses = root.parseProcesses(this.text)
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

            root.parseMem(root.readFile(memFile));

            const busy = root.readFile(gpuBusyFile);
            root.gpuPercent = busy === null ? -1 : root.parsePercent(busy);

            root.cpuHistory = root.pushSample(root.cpuHistory, root.cpuPercent);
            root.gpuHistory = root.pushSample(root.gpuHistory, root.gpuPercent);
            root.memHistory = root.pushSample(root.memHistory, root.memPercent);
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.sensorVanished = false;
            root.sensors.forEach(sensor => sensor.sample());

            if (root.sensorVanished && !resolver.running)
                resolver.running = true;
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true

        onTriggered: {
            if (root.sensors.some(sensor => sensor.dir === "") && !resolver.running)
                resolver.running = true;
        }
    }

    Timer {
        id: topTimer

        interval: 5000
        running: root.dashboardOpen
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!topProcess.running)
                topProcess.running = true;
        }
    }

    Timer {
        interval: 30000
        running: root.dashboardOpen
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!diskProcess.running)
                diskProcess.running = true;
        }
    }
}
