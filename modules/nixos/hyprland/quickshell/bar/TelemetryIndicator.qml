import QtQuick
import qs.popouts
import qs.services as Services
import qs.theme

Row {
    id: root

    required property var bar

    property string emphasis: ""

    spacing: Theme.spacingNormal

    function open(key: string): void {
        const reopening = root.bar.popout === "telemetry" && root.emphasis === key;
        root.emphasis = key;

        if (reopening)
            root.bar.closePopout();
        else
            root.bar.popout = "telemetry";
    }

    component Stat: Item {
        id: stat

        required property string key
        required property string label
        required property int percent
        property real temp: -1
        property string level: "normal"

        readonly property bool showTemp: stat.level !== "normal"

        implicitWidth: content.implicitWidth + 2 * Theme.spacingSmall
        implicitHeight: Theme.barHeight - 2 * Theme.spacingSmall

        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: parent.width
            height: parent.height
            radius: Theme.radius
            color: {
                if (stat.level === "critical")
                    return Theme.critical;
                if (stat.level === "warning")
                    return Theme.warning;
                return "transparent";
            }

            anchors.centerIn: parent
            anchors.verticalCenterOffset: -1

            Behavior on color {
                ColorAnimation {
                    duration: Theme.animationFast
                }
            }
        }

        Row {
            id: content

            anchors.centerIn: parent
            spacing: Theme.spacingSmall

            Text {
                text: stat.label
                color: stat.showTemp ? Theme.background : Theme.mutedText
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                textFormat: Text.PlainText
            }

            Text {
                text: {
                    if (stat.showTemp)
                        return Math.round(stat.temp) + "°";
                    if (stat.percent < 0)
                        return "--";
                    return stat.percent + "%";
                }
                color: stat.showTemp ? Theme.background : Theme.text
                width: metrics.width
                horizontalAlignment: Text.AlignRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                textFormat: Text.PlainText
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: root.open(stat.key)
        }
    }

    TextMetrics {
        id: metrics

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        text: "100%"
    }

    Stat {
        key: "cpu"
        label: "CPU"
        percent: Services.Telemetry.cpuPercent
        temp: Services.Telemetry.effectiveCpuTemp
        level: Services.Telemetry.cpuLevel
    }

    Stat {
        key: "gpu"
        label: "GPU"
        percent: Services.Telemetry.gpuPercent
        temp: Services.Telemetry.effectiveGpuTemp
        level: Services.Telemetry.gpuLevel
    }

    Stat {
        key: "memory"
        label: "RAM"
        percent: Services.Telemetry.memPercent
    }

    TelemetryPopout {
        bar: root.bar
        source: root
        emphasis: root.emphasis
    }
}
