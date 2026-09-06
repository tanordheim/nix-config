import QtQuick
import Quickshell
import qs.components
import qs.theme

Popout {
    id: root

    property int monthOffset: 0

    readonly property date today: clock.date
    readonly property string todayKey: Qt.formatDate(root.today, "yyyy-MM-dd")
    readonly property date shown: new Date(root.today.getFullYear(), root.today.getMonth() + root.monthOffset, 1)
    readonly property var days: root.buildDays(root.shown, root.todayKey)

    name: "calendar"
    contentWidth: 7 * Theme.calendarCell

    function buildDays(month: date, todayKey: string): var {
        const leading = (month.getDay() + 6) % 7;
        const cells = [];

        for (let i = 0; i < 42; i++) {
            const day = new Date(month.getFullYear(), month.getMonth(), 1 - leading + i);
            cells.push({
                label: day.getDate(),
                inMonth: day.getMonth() === month.getMonth(),
                isToday: Qt.formatDate(day, "yyyy-MM-dd") === todayKey
            });
        }

        return cells;
    }

    onVisibleChanged: {
        if (!root.visible)
            root.monthOffset = 0;
    }

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Row {
        width: root.contentWidth
        spacing: Theme.spacingSmall

        IconButton {
            id: previous

            text: "󰅁"

            onClicked: root.monthOffset--
        }

        Text {
            text: Qt.formatDate(root.shown, "MMMM yyyy")
            color: Theme.text
            width: parent.width - previous.width - current.width - next.width - 3 * parent.spacing
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            textFormat: Text.PlainText

            anchors.verticalCenter: parent.verticalCenter
        }

        IconButton {
            id: current

            text: "󰃭"
            foreground: root.monthOffset === 0 ? Theme.mutedText : Theme.accent

            onClicked: root.monthOffset = 0
        }

        IconButton {
            id: next

            text: "󰅂"

            onClicked: root.monthOffset++
        }
    }

    Grid {
        columns: 7

        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

            delegate: Text {
                required property string modelData

                text: modelData
                color: Theme.mutedText
                width: Theme.calendarCell
                height: Theme.calendarCell
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.PlainText
            }
        }

        Repeater {
            model: root.days

            delegate: Item {
                id: cell

                required property var modelData

                implicitWidth: Theme.calendarCell
                implicitHeight: Theme.calendarCell

                Rectangle {
                    visible: cell.modelData.isToday
                    anchors.centerIn: parent
                    width: Theme.calendarCell - Theme.spacingSmall
                    height: width
                    radius: width / 2
                    color: Theme.accent
                }

                Text {
                    anchors.centerIn: parent
                    text: cell.modelData.label
                    color: {
                        if (cell.modelData.isToday)
                            return Theme.background;
                        return cell.modelData.inMonth ? Theme.text : Theme.separator;
                    }
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    textFormat: Text.PlainText
                }
            }
        }
    }
}
