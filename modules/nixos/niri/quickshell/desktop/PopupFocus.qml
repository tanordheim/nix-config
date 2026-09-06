import QtQuick

Binding {
    id: root

    required property var popup

    target: root.popup
    property: "grabFocus"
    value: true
}
