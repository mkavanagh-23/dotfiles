import Quickshell
import Quickshell.Io
import QtQuick

Item {
  implicitWidth: networkText.implicitWidth
  implicitHeight: networkText.implicitHeight

  property string connectionType: "disconnected"
  property string connectionName: ""
  property int wifiSignal: 0

  // Get the connected network
  Process {
    id: networkProc

    command: [
      "nmcli",
      "-t",
      "-f",
      "DEVICE,TYPE,STATE,CONNECTION",
      "device"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        connectionType = "disconnected"
        connectionName = ""
        wifiSignal = 0

        const lines = this.text.trim().split("\n")

        for (const line of lines) {
          const parts = line.split(":")

          if (parts.length < 4) {
            continue
          }
          
          const device = parts[0]
          const type = parts[1]
          const state = parts[2]
          const connection = parts.slice(3).join(":")

          if (state !== "connected") {
            continue
          }

          if (type === "ethernet") {
            connectionType = "ethernet"
            connectionName = connection
          } else if (type === "wifi" && connectionType !== "ethernet") {
            connectionType = "wifi"
            connectionName = connection
          }
        }
      }
    }
  }

  // Get the wifi signal strength
  Process {
    id: wifiProc

    command: [
      "nmcli",
      "-t",
      "-f",
      "IN-USE,SIGNAL",
      "device",
      "wifi"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const lines = this.text.trim().split("\n")

        for (const line of lines) {
          const parts = line.split(":")

          if (parts.length >= 2 && parts[0] === "*") {
            wifiSignal = parseInt(parts[1])
            break
          }
        }
      }
    }
  }

  // Run processes on a timer
  Timer {
    interval: 5000
    running: true
    repeat: true

    onTriggered: {
      networkProc.running = true
      wifiProc.running = true
    }
  }

  Text {
    id: networkText
    text: {
      if (connectionType === "ethernet") {
        return "󰈀"
      }

      if (connectionType === "wifi") {
        if (wifiSignal >= 80) return "󰤨"
        if (wifiSignal >= 80) return "󰤥"
        if (wifiSignal >= 80) return "󰤢"
        if (wifiSignal >= 80) return "󰤟"
        return "󰤯"
      }

      return "󰤭"
    }
    color: "#cdd6f4"
  }
}
