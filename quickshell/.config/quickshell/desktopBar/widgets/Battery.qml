import QtQuick
import Quickshell.Services.UPower

Item {
  implicitWidth: batteryPercent.implicitWidth
  implicitHeight: batteryPercent.implicitHeight

  Text {
    id: batteryPercent

    text: "bat " + UPower.displayDevice.percentage * 100 + "%"
    color: "#cdd6f4"
  }
}
