import QtQuick
import qs.theme

Item {
    id: root

    required property var values
    required property int slots

    property color barColor: Theme.accent

    readonly property real barWidth: (root.width - (root.slots - 1) * Theme.histogramGap) / root.slots

    implicitWidth: Theme.histogramWidth
    implicitHeight: Theme.histogramHeight

    function sample(index: int): real {
        const offset = root.slots - root.values.length;
        return index < offset ? -1 : root.values[index - offset];
    }

    Row {
        anchors.fill: parent
        spacing: Theme.histogramGap

        Repeater {
            model: root.slots

            delegate: Item {
                id: column

                required property int index

                readonly property real value: root.sample(column.index)

                width: root.barWidth
                height: root.height

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: column.value < 0 ? 1 : Math.max(1, parent.height * column.value / 100)
                    radius: width / 2
                    color: column.value < 0 ? Theme.separator : root.barColor
                    opacity: column.value < 0 ? Theme.dimOpacity : 1
                }
            }
        }
    }
}
