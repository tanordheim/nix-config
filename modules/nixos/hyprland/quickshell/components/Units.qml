pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property var suffixes: ["B", "kB", "MB", "GB", "TB", "PB"]

    function scaleOf(value: real): int {
        if (value <= 0)
            return 0;
        return Math.min(root.suffixes.length - 1, Math.floor(Math.log(value) / Math.log(1024)));
    }

    function scaled(value: real, scale: int, decimals: int): string {
        return (value / Math.pow(1024, scale)).toFixed(decimals);
    }

    function bytes(value: real, decimals: int): string {
        if (value < 0)
            return "--";

        const scale = root.scaleOf(value);
        return root.scaled(value, scale, decimals) + " " + root.suffixes[scale];
    }

    function pair(used: real, total: real): string {
        if (used < 0 || total <= 0)
            return "--";

        const scale = root.scaleOf(total);
        return root.scaled(used, scale, 1) + " / " + root.scaled(total, scale, 0) + " " + root.suffixes[scale];
    }

    function rate(value: real): string {
        if (value < 0)
            return "--";
        return root.bytes(value, 1) + "/s";
    }
}
