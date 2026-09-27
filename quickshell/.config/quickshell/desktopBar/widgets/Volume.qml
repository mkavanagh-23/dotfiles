import QtQuick
import Quickshell.Services.Pipewire

Item {
  implicitWidth: volumePercent.implicitWidth
  implicitHeight: volumePercent.implicitHeight

  Text {
    id: volumePercent

    text: Pipewire.defaultAudioSink?.audio?.muted
      ?"mute"
      : "vol " + Math.round((Pipewire.defaultAudioSink?.audio?.volume ?? 0) * 100) + "%"
      
    color: "#cdd6f4"
  }

  PwObjectTracker { objects: [Pipewire.defaultAudioSink] }
}
