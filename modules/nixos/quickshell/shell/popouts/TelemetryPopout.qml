import QtQuick
import qs.components
import qs.services as Services
import qs.theme

Popout {
    id: root

    property string emphasis: ""
    property bool flashing: false

    name: "telemetry"
    contentWidth: Theme.popoutWidthWide

    function percentLabel(value: real): string {
        return (value >= 10 ? value.toFixed(0) : value.toFixed(1)) + "%";
    }

    function flash(): void {
        root.flashing = true;
        flashTimer.restart();
    }

    function tempLabel(temp: real): string {
        return temp < 0 ? "--" : Math.round(temp) + "°C";
    }

    function fanLabel(rpm: real): string {
        return rpm < 0 ? "--" : Math.round(rpm) + " rpm";
    }

    function levelColor(level: string): color {
        if (level === "critical")
            return Theme.critical;
        if (level === "warning")
            return Theme.warning;
        return Theme.text;
    }

    function coreColor(value: real): color {
        if (value < 0)
            return Theme.separator;
        if (value >= Services.Telemetry.cpuUtilizationCritical)
            return Theme.critical;
        if (value >= Services.Telemetry.cpuUtilizationWarning)
            return Theme.warning;
        return Theme.accent;
    }


    onVisibleChanged: {
        if (root.visible)
            root.flash();
        else
            root.flashing = false;
    }

    onEmphasisChanged: {
        if (root.visible)
            root.flash();
    }

    component LabelText: Text {
        color: Theme.mutedText
        width: Theme.labelColumnWidth
        elide: Text.ElideRight
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText

        anchors.verticalCenter: parent.verticalCenter
    }

    component ValueText: Text {
        color: Theme.text
        horizontalAlignment: Text.AlignRight
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
        textFormat: Text.PlainText

        anchors.verticalCenter: parent.verticalCenter
    }

    component Card: Rectangle {
        id: card

        required property string key
        required property string label
        required property int percent
        required property var history
        property string tempDetail: ""
        property string tempLevel: "normal"
        property string detail: ""

        readonly property bool emphasized: root.flashing && root.emphasis === card.key

        implicitWidth: cardRow.implicitWidth + 2 * Theme.spacingNormal
        implicitHeight: Math.max(Theme.rowHeight, cardRow.implicitHeight + Theme.spacingSmall)
        radius: Theme.radius
        color: card.emphasized ? Theme.hoverSurface : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.animationFast
            }
        }

        Row {
            id: cardRow

            anchors.fill: parent
            anchors.leftMargin: Theme.spacingNormal
            anchors.rightMargin: Theme.spacingNormal
            spacing: Theme.spacingNormal

            LabelText {
                text: card.label
            }

            ValueText {
                text: card.percent < 0 ? "--" : card.percent + "%"
                width: Theme.valueColumnWidth
            }

            Histogram {
                values: card.history
                slots: Services.Telemetry.historyLength
                width: cardRow.width - Theme.labelColumnWidth - Theme.valueColumnWidth - Theme.tempColumnWidth - Theme.detailColumnWidth - 4 * Theme.spacingNormal

                anchors.verticalCenter: parent.verticalCenter
            }

            ValueText {
                text: card.tempDetail
                color: root.levelColor(card.tempLevel)
                width: Theme.tempColumnWidth
            }

            ValueText {
                text: card.detail
                width: Theme.detailColumnWidth
            }
        }
    }

    component DetailRow: Item {
        id: detailRow

        required property string label
        required property string value
        property color valueColor: Theme.text

        implicitWidth: labelText.implicitWidth + valueText.implicitWidth + 3 * Theme.spacingNormal
        implicitHeight: Theme.rowHeight

        LabelText {
            id: labelText

            text: detailRow.label

            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingNormal
        }

        ValueText {
            id: valueText

            text: detailRow.value
            color: detailRow.valueColor

            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingNormal
        }
    }

    Timer {
        id: flashTimer

        interval: Theme.animationSlow

        onTriggered: root.flashing = false
    }

    Binding {
        target: Services.Telemetry
        property: "dashboardOpen"
        value: true
        when: root.visible
        restoreMode: Binding.RestoreBindingOrValue
    }

    SectionHeader {
        text: "System"
    }

    Card {
        key: "cpu"
        label: "CPU"
        percent: Services.Telemetry.cpuPercent
        history: Services.Telemetry.cpuHistory
        tempDetail: root.tempLabel(Services.Telemetry.cpuTemp)
        tempLevel: Services.Telemetry.cpuLevel
        detail: root.fanLabel(Services.Telemetry.cpuFan)
        width: root.contentWidth
    }

    Item {
        id: coreStrip

        readonly property var cores: Services.Telemetry.corePercents

        implicitHeight: Theme.histogramHeight + Theme.spacingSmall
        width: root.contentWidth

        LabelText {
            text: "Cores"

            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingNormal
        }

        Item {
            id: coreBars

            height: Theme.histogramHeight

            anchors.left: parent.left
            anchors.leftMargin: Theme.labelColumnWidth + 2 * Theme.spacingNormal
            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingNormal
            anchors.verticalCenter: parent.verticalCenter

            Row {
                anchors.fill: parent
                spacing: Theme.histogramGap

                Repeater {
                    model: coreStrip.cores.length

                    delegate: Item {
                        id: coreColumn

                        required property int index

                        readonly property real value: coreStrip.cores[coreColumn.index] ?? -1

                        width: (coreBars.width - (coreStrip.cores.length - 1) * Theme.histogramGap) / coreStrip.cores.length
                        height: coreBars.height

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: coreColumn.value < 0 ? 1 : Math.max(1, parent.height * coreColumn.value / 100)
                            radius: width / 2
                            color: root.coreColor(coreColumn.value)
                            opacity: coreColumn.value < 0 ? Theme.dimOpacity : 1
                        }
                    }
                }
            }
        }
    }

    Card {
        key: "gpu"
        label: "GPU"
        percent: Services.Telemetry.gpuPercent
        history: Services.Telemetry.gpuHistory
        tempDetail: root.tempLabel(Services.Telemetry.gpuTemp)
        tempLevel: Services.Telemetry.gpuLevel
        detail: root.fanLabel(Services.Telemetry.gpuFan)
        width: root.contentWidth
    }

    Card {
        key: "memory"
        label: "Memory"
        percent: Services.Telemetry.memPercent
        history: Services.Telemetry.memHistory
        detail: Units.pair(Services.Telemetry.memUsedBytes, Services.Telemetry.memTotalBytes)
        width: root.contentWidth
    }

    SectionHeader {
        text: "Storage"
    }

    DetailRow {
        label: "/"
        value: Units.pair(Services.Telemetry.diskUsedBytes, Services.Telemetry.diskTotalBytes)
        width: root.contentWidth
    }

    DetailRow {
        label: "NVMe"
        value: root.tempLabel(Services.Telemetry.nvmeTemp)
        valueColor: root.levelColor(Services.Telemetry.nvmeLevel)
        width: root.contentWidth
    }

    DetailRow {
        label: "DIMM"
        value: root.tempLabel(Services.Telemetry.dimmTemp)
        valueColor: root.levelColor(Services.Telemetry.dimmLevel)
        width: root.contentWidth
    }

    SectionHeader {
        text: "Cooling"
    }

    DetailRow {
        label: "Chassis"
        value: root.fanLabel(Services.Telemetry.chassisFan1) + " / " + root.fanLabel(Services.Telemetry.chassisFan2)
        width: root.contentWidth
    }

    Item {
        implicitHeight: Theme.rowHeight
        width: root.contentWidth

        SectionHeader {
            text: "Top processes"

            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingNormal
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            spacing: Theme.spacingNormal

            anchors.right: parent.right
            anchors.rightMargin: Theme.spacingNormal
            anchors.verticalCenter: parent.verticalCenter

            IconButton {
                text: "CPU"
                selected: Services.Telemetry.sortByCpu
                foreground: Services.Telemetry.sortByCpu ? Theme.accent : Theme.mutedText

                onClicked: Services.Telemetry.sortByCpu = true
            }

            IconButton {
                text: "RAM"
                selected: !Services.Telemetry.sortByCpu
                foreground: Services.Telemetry.sortByCpu ? Theme.mutedText : Theme.accent

                onClicked: Services.Telemetry.sortByCpu = false
            }
        }
    }

    Repeater {
        model: Services.Telemetry.topProcesses

        delegate: Item {
            id: process

            required property var modelData

            implicitHeight: Theme.rowHeight
            width: root.contentWidth

            Text {
                text: process.modelData.name
                color: Theme.text
                width: parent.width - 2 * Theme.valueColumnWidth - 3 * Theme.spacingNormal
                elide: Text.ElideRight
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                textFormat: Text.PlainText

                anchors.left: parent.left
                anchors.leftMargin: Theme.spacingNormal
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                spacing: Theme.spacingNormal

                anchors.right: parent.right
                anchors.rightMargin: Theme.spacingNormal
                anchors.verticalCenter: parent.verticalCenter

                ValueText {
                    text: root.percentLabel(process.modelData.cpu)
                    width: Theme.valueColumnWidth
                }

                ValueText {
                    text: root.percentLabel(process.modelData.mem)
                    width: Theme.valueColumnWidth
                }
            }
        }
    }
}
