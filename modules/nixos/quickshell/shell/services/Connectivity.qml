pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking
import qs.config

Singleton {
    id: root

    readonly property real sampleSeconds: 2

    property bool panelOpen: false

    readonly property WiredDevice device: Networking.devices.values.find(device => device.type === DeviceType.Wired) ?? null
    readonly property bool connected: root.device !== null && root.device.connected
    readonly property bool hasLink: root.device !== null && root.device.hasLink
    readonly property string interfaceName: root.device !== null ? root.device.name : ""
    readonly property int linkSpeed: root.device !== null ? root.device.linkSpeed : 0

    readonly property string statisticsDir: root.interfaceName === "" ? "" : Config.networkStatistics + "/" + root.interfaceName + "/statistics"

    property string address: ""
    property string gateway: ""
    property var dnsServers: []

    property real downRate: 0
    property real upRate: 0
    property real sessionDown: 0
    property real sessionUp: 0

    property real rxBaseline: -1
    property real txBaseline: -1
    property real prevRx: -1
    property real prevTx: -1
    property bool readFailed: false

    function copyAddress(): void {
        if (root.address !== "")
            Quickshell.clipboardText = root.address;
    }

    function readFile(view): var {
        root.readFailed = false;
        view.reload();
        return root.readFailed ? null : view.text();
    }

    function counter(view): real {
        const text = root.readFile(view);
        if (text === null)
            return -1;

        const value = Number(text.trim());
        return isNaN(value) ? -1 : value;
    }

    function resetCounters(): void {
        root.rxBaseline = -1;
        root.txBaseline = -1;
        root.prevRx = -1;
        root.prevTx = -1;
        root.downRate = 0;
        root.upRate = 0;
        root.sessionDown = 0;
        root.sessionUp = 0;
    }

    function sampleCounters(): void {
        const rx = root.counter(rxFile);
        const tx = root.counter(txFile);

        if (rx < 0 || tx < 0) {
            root.resetCounters();
            return;
        }

        if (root.rxBaseline < 0 || rx < root.rxBaseline || tx < root.txBaseline) {
            root.rxBaseline = rx;
            root.txBaseline = tx;
        }

        root.sessionDown = rx - root.rxBaseline;
        root.sessionUp = tx - root.txBaseline;

        if (root.prevRx >= 0 && rx >= root.prevRx && tx >= root.prevTx) {
            root.downRate = (rx - root.prevRx) / root.sampleSeconds;
            root.upRate = (tx - root.prevTx) / root.sampleSeconds;
        } else {
            root.downRate = 0;
            root.upRate = 0;
        }

        root.prevRx = rx;
        root.prevTx = tx;
    }

    function parseGateway(text: var, iface: string): string {
        if (text === null || iface === "")
            return "";

        for (const line of text.split("\n").slice(1)) {
            const fields = line.trim().split(/\s+/);
            if (fields.length < 3 || fields[0] !== iface || fields[1] !== "00000000" || fields[2] === "00000000")
                continue;

            return [3, 2, 1, 0].map(index => parseInt(fields[2].substr(index * 2, 2), 16)).join(".");
        }

        return "";
    }

    function parseDns(text: var): var {
        if (text === null)
            return [];

        return text.split("\n").filter(line => line.startsWith("nameserver ")).map(line => line.slice(11).trim()).filter(entry => entry !== "");
    }

    function parseAddress(text: string): string {
        const match = text.match(/inet\s+([0-9.]+)/);
        return match === null ? "" : match[1];
    }

    function refreshRouting(): void {
        root.gateway = root.parseGateway(root.readFile(routeFile), root.interfaceName);
        root.dnsServers = root.parseDns(root.readFile(resolvFile));

        if (root.interfaceName === "") {
            root.address = "";
            return;
        }

        if (!addressProcess.running)
            addressProcess.running = true;
    }

    function initialize(): void {
        root.sampleCounters();
        root.refreshRouting();
    }

    onInterfaceNameChanged: {
        root.resetCounters();
        Qt.callLater(root.initialize);
    }

    onConnectedChanged: root.refreshRouting()

    onPanelOpenChanged: {
        root.prevRx = -1;
        root.prevTx = -1;
        root.downRate = 0;
        root.upRate = 0;

        if (root.panelOpen)
            root.refreshRouting();
    }

    Component.onCompleted: Qt.callLater(root.initialize)

    FileView {
        id: rxFile

        path: root.statisticsDir === "" ? "" : root.statisticsDir + "/rx_bytes"
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: txFile

        path: root.statisticsDir === "" ? "" : root.statisticsDir + "/tx_bytes"
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: routeFile

        path: Config.routeTable
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    FileView {
        id: resolvFile

        path: Config.resolvConf
        preload: false
        blockAllReads: true
        printErrors: false

        onLoadFailed: root.readFailed = true
    }

    Process {
        id: addressProcess

        command: [Config.ipBinary, "-4", "-oneline", "address", "show", "dev", root.interfaceName]

        stdout: StdioCollector {
            onStreamFinished: root.address = root.parseAddress(this.text)
        }
    }

    Timer {
        interval: root.sampleSeconds * 1000
        running: root.panelOpen
        repeat: true
        triggeredOnStart: true

        onTriggered: root.sampleCounters()
    }
}
