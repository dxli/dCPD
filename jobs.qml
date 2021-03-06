/* TODO:

  1. Better to create a visual separator like a vertical
     straight line between columns for more comprehensive look

  2. Move from listmodel to a context property
     obtained from backend

  3. Add color to indicate right-clicked job

  4. Check if one right click menu can be used for all jobs

*/

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

Rectangle{
    width: parent.width
    height: parent.height

    Rectangle {
        width: parent.width
        height: location_heading.contentHeight // Since "Location" is the biggest word in this row,
                                               // it will be the first to get wrapped
        Text {
            x: 20
            y: 10
            width: parent.width/3 - 20
            text: "Printer"
            font.bold: true
            wrapMode: Text.Wrap
        }

        Text {
            id: location_heading
            x: parent.width/3 + 20
            y: 10
            width: parent.width/3 - 20
            text: "Location"
            font.bold: true
            wrapMode: Text.Wrap
        }

        Text {
            x: 2*parent.width/3 + 20
            y: 10
            width: parent.width/3 - 20
            text: "Status"
            font.bold: true
            wrapMode: Text.Wrap
        }
    }

    ListModel{
        id: jobs_model

        ListElement{
            printer: "Canon Pixma"
            location: "Office Desk"
            status: "Completed"
        }

        ListElement{
            printer: "HP Laser Jet"
            location: "Home"
            status: "Running"
        }

        ListElement{
            printer: "Xerox"
            location: "Office Reception"
            status: "Pending"
        }
    }

    ListView {
        id: jobs_view
        width: parent.width
        height: parent.height - 200
        model: jobs_model
        y: location_heading.contentHeight + 20

        delegate: Rectangle {
            width: parent.width
            height: Math.max(printer_text.contentHeight, location_text.contentHeight, status_text.contentHeight) + 10
            color: (model.index % 2 == 0) ? "#EEEEEE" : "white"

            Menu {
                id: menu

                MenuItem{ text: "Pause" }
                MenuItem{ text: "Stop" }
                MenuItem{ text: "Cancel" }
                MenuItem{ text: "Repeat" }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                hoverEnabled: true

                onEntered: { parent.color = "#BDBDBD"}
                onExited:  { parent.color = (model.index % 2 == 0) ? "#EEEEEE" : "white"}
                onClicked: {
                    menu.x = mouseX
                    menu.y = mouseY
                    menu.open()
                }
            }

            Text {
                id: printer_text
                x: 20
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width/3 - 20
                text: printer
                wrapMode: Text.Wrap
            }

            Text {
                id: location_text
                x: parent.width/3 + 20
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width/3 - 20
                text: location
                wrapMode: Text.Wrap
            }

            Text {
                id: status_text
                x: 2*parent.width/3 + 20
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width/3 - 20
                text: status
                wrapMode: Text.Wrap
            }
        }
    }

    Text {
        x: 20
        y: parent.height - 147
        text: "Start Job : "
    }

    ComboBox {
        id: start_job_combobox
        x: 120
        y: parent.height - 155
        width: (start_job_combobox.currentIndex==1) ? parent.width - 280 : parent.width - 180
        height: 40
        font.pixelSize: 12
        model: ["Immediately", "After a delay of", "Never"]
    }

    TextField {
        x: parent.width - 150
        y: parent.height - 145
        width: 60
        height: 30
        font.pointSize: 10
        visible: (start_job_combobox.currentIndex==1) ? true :  false
    }

    Text {
        text: "Minutes"
        x: parent.width - 80
        y: parent.height - 145
        visible: (start_job_combobox.currentIndex==1) ? true :  false
    }

    Text {
        x: 20
        y: parent.height - 97
        text: "Save Job : "
    }

    Switch {
        id: save_job_switch
        x: 105
        y: parent.height - 110
    }

    Button {
        x: 200
        y: parent.height - 110
        height: 40
        text: "Browse"
        visible: (save_job_switch.checked) ? true : false
        onClicked: { file_dialog.open() }
    }

    Text {
        text: "Location : "
        x: 20
        y: parent.height - 50
        visible: (save_job_switch.checked) ? true : false
    }

    Text {
        id: save_job_location
        text: "None"
        x: 120
        y: parent.height - 50
        visible: (save_job_switch.checked) ? true : false
    }

    FileDialog {
        id: file_dialog
        title: "Please choose a folder"
        folder: shortcuts.home
        selectFolder: true
        onAccepted: {
            save_job_location.text = file_dialog.fileUrl.toString().substring(7)
            file_dialog.close()
        }
        onRejected: {
            file_dialog.close()
        }
    }
}
