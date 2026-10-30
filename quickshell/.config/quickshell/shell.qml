//@ pragma UseQApplication
// Quickshell configuration: top bar + small QS modal.
// Bar shows QS toggle, workspaces, focused window title and clock.
// QS modal shows reload action.

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

ShellRoot {
    // Main top bar spanning the screen width
    PanelWindow {
        id: bar

        // Anchor the panel to the top edge of the screen
        anchors {
            top: true
            left: true
            right: true
        }

        // Height of the top bar in pixels
        implicitHeight: 33
        // Bar background color
        color: "#111318"

        // Whether the QS modal is currently open
        property bool centerOpen: false

        // Whether the hidden system tray is expanded
        property bool trayOpen: false

        // Auto-close modal after 6 seconds
        Timer {
            id: centerTimer
            interval: 6000
            running: false
            repeat: false
            onTriggered: bar.centerOpen = false
        }

        // Layout row containing all bar elements
        RowLayout {
            anchors.fill: parent
            anchors.margins: 3
            spacing: 0

            // QS toggle button (small square on the far left)
            Item {
                Layout.preferredWidth: 25
                Layout.preferredHeight: 0
                Layout.alignment: Qt.AlignVCenter
                Rectangle {
                    anchors.centerIn: parent
                    width: 32; height: 32; radius: 0
                    color: "#22222a"
                    border.color: "#9f78bd"
                    border.width: 1
                    // QS is shown as a colored "*" icon
                    Text { anchors.centerIn: parent; text: "*"; color: "#9f78bd"; font.pixelSize: 14; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                    // Click toggles the QS modal
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            bar.centerOpen = !bar.centerOpen
                            if (bar.centerOpen) centerTimer.restart()
                        }
                    }
                }
            }

            // Spacer between QS button and workspace numbers
            Item { Layout.preferredWidth: 16 }

            // Workspace numbers: click a number to switch to that workspace
            Row {
                spacing: 2
                Layout.alignment: Qt.AlignVCenter

                Repeater {
                    model: Hyprland.workspaces

                    delegate: Text {
                        required property var modelData

                        text: "[" + (modelData.name || modelData.id) + "]  "
                        color: modelData.focused ? "#9f78bd" : "#ffffff"
                        font.pixelSize: 14

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.activate()
                        }
                    }
                }
            }

            // Push the remaining elements to the right
            Item { Layout.fillWidth: true }

            // Currently focused window title
            Text {
                text: Hyprland.focusedWindow?.title ?? ""
                color: "#9aa0ab"
                font.pixelSize: 13
                elide: Text.ElideRight
                Layout.alignment: Qt.AlignVCenter
            }

            // Spacer between focused window title and tray/clock
            Item { Layout.preferredWidth: 8 }

            // "v" button to the left of the clock; opens the tray under it
            Row {
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: -20

                // Toggle (open/close) the tray
                Text {
                    id: trayToggle
                    text: "v"
                    color: "#9aa0ab"
                    font.pixelSize: 14

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bar.trayOpen = !bar.trayOpen
                    }
                }
            }

            // Current time in 24-hour format
            Text {
                id: clockText
                color: "#e0e0e6"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
                text: Qt.formatTime(new Date(), "HH:mm")
            }
        }

        // Update the clock once per second
        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: clockText.text = Qt.formatTime(new Date(), "HH:mm")
        }
    }

    // Tray popup shown under the "v" button
    PanelWindow {
        id: trayPopup
        visible: bar.trayOpen

        anchors { top: true; left: true }
        margins.top: 5
        margins.left: Math.max(0, trayToggle.mapToItem(bar.contentItem, 0, 0).x + trayToggle.width - (trayRow.implicitWidth + 12))

        implicitWidth: trayRow.implicitWidth + 12
        implicitHeight: 30
        color: "#22222a"

        Row {
            id: trayRow
            anchors.centerIn: parent
            spacing: 6

            Repeater {
                model: SystemTray.items

                delegate: Item {
                    required property var modelData

                    implicitWidth: 18
                    implicitHeight: 18

                    Image {
                        anchors.fill: parent
                        source: modelData.icon
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {

                            if (mouse.button === Qt.RightButton) {
                                if (modelData.hasMenu) {
                                    const pos = parent.mapToItem(trayPopup.contentItem, mouse.x, mouse.y)
                                    modelData.display(trayPopup, pos.x, pos.y)
                                }
                            } else if (modelData.onlyMenu && modelData.hasMenu) {
                                const posLeft = parent.mapToItem(trayPopup.contentItem, mouse.x, mouse.y)
                                modelData.display(trayPopup, posLeft.x, posLeft.y)
                            } else {
                                modelData.activate()
                                bar.trayOpen = false
                            }
                        }
                    }
                }
            }
        }
    }

    // Small modal shown near the QS button
    PanelWindow {
        id: qsModal
        // Modal follows the QS button open state
        visible: bar.centerOpen
        // Fixed small position near the QS button
        anchors { top: true; left: true }
        implicitWidth: 250
        implicitHeight: 48
        color: "transparent"
        margins.top: 0
        margins.left: 0

        // Modal background with purple outline
        Rectangle {
            anchors.fill: parent
            color: "#22222a"
            radius: 0
            border.color: "#9f78bd"
            border.width: 2

            // Centered vertical stack
            Column {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 4

                // Clickable reload action
                Rectangle {
                    width: parent.width
                    height: 30
                    color: "#22222a"

                    // Reload label (gray text)
                    Text {
                        anchors.centerIn: parent
                        text: "Reload hyprland and quickshell"
                        color: "#9aa0ab"
                        font.pixelSize: 12
                    }

                    // Click runs the reload command and closes modal
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            bar.centerOpen = false
                            reloadAll.running = true
                        }
                    }
                }
            }

            // Background process that performs the actual reload
            Process {
                id: reloadAll
                command: ["bash","-c","hyprctl reload && pkill -x quickshell; sleep .3; setsid quickshell >/dev/null 2>&1 &"]
                running: false
            }
        }
    }
}
