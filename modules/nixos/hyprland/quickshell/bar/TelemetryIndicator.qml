import QtQuick
import qs.services as Services
import qs.theme

Row {
    id: root

    spacing: Theme.spacingNormal

    component Stat: Rectangle {
        id: stat

        required property string label
        required property int percent
        property real temp: -1
        property string level: "normal"

        readonly property bool showTemp: stat.level !== "normal"

        radius: Theme.radius
        color: {
            if (stat.level === "critical")
                return Theme.critical;
            if (stat.level === "warning")
                return Theme.warning;
            return "transparent";
        }
        implicitWidth: content.implicitWidth + 2 * Theme.spacingSmall
        implicitHeight: Theme.barHeight - 2 * Theme.spacingSmall

        anchors.verticalCenter: parent.verticalCenter

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
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
    }

    TextMetrics {
        id: metrics

        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        text: "100%"
    }

    Stat {
        label: "CPU"
        percent: Services.Telemetry.cpuPercent
        temp: Services.Telemetry.effectiveCpuTemp
        level: Services.Telemetry.cpuLevel
    }

    Stat {
        label: "GPU"
        percent: Services.Telemetry.gpuPercent
        temp: Services.Telemetry.effectiveGpuTemp
        level: Services.Telemetry.gpuLevel
    }

    Stat {
        label: "RAM"
        percent: Services.Telemetry.memPercent
    }
}
