import Quickshell;
import Quickshell.Io;
import QtQuick;

Scope {
  id: root
  required property var command;
  required property DataStreamParser parseOut;
  required property int interval;

  Process {
    id: process
    command: root.command;
    stdout: root.parseOut;
  }

  Timer {
    running: true;
    interval: root.interval;
    triggeredOnStart: true;
    repeat: true;
    onTriggered: {
      process.running = true
    }
  }
}

