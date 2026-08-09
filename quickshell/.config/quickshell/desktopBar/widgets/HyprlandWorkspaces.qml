import QtQuick
import Quickshell.Hyprland

Repeater {
  model: Hyprland.workspaces

  Text {
    text: modelData.id
    color: "#cdd6f4"
  }
}
