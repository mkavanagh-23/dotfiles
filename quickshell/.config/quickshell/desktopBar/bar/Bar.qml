import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.widgets

Scope {
  Variants {
    // Variants Quickshell.screens to create separate instance for each monitor
    model: Quickshell.screens

    // Create the panel window for the bar
    PanelWindow {
      required property var modelData

      screen: modelData

      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 42

      Rectangle {
        anchors.fill: parent
        color: "#8A161617"

        // Left modules
        RowLayout {
          anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 20
          }

          spacing: 10
          
          // workspaces go here
          HyprlandWorkspaces {}
        }

        // Center Modules
        RowLayout {
          anchors {
            centerIn: parent
          }

          spacing: 10
          
          Clock {}
        }

        //Right Modules
        RowLayout {
          anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 20
          }

          spacing: 20
          
          // right widgets go here
          Network {}
          Volume {}
          Battery {}
        }
      }
    }
  }
}
