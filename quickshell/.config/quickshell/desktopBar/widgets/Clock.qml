import Quickshell
import QtQuick

Item {
  implicitWidth: clockText.implicitWidth
  implicitHeight: clockText.implicitHeight

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Text {
    id: clockText

    text: "󰣇 " + Qt.formatDateTime(clock.date, "HH:mm")
    color: "#cdd6f4"
  }
}

