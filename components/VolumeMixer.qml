import qs.singletons
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Pipewire;

Item {
  id: root;

  readonly property var appStreams: Pipewire.nodes.values
    .filter((node) => node.isStream && node.audio !== null);

  PwObjectTracker { objects: root.appStreams }

  implicitHeight: column.implicitHeight;
  implicitWidth: column.implicitWidth;

  ColumnLayout {
    id: column;

    spacing: Consts.paddingModule;

    VolumeMixerItem {
      node: SysInfo.audioNode;
      useNickname: true;
      iconOverride: SysInfo.volumeIcon;
    }

    Rectangle {
      color: Globals.colours.outline;
      implicitHeight: 1;
      Layout.fillWidth: true;
    }

    Repeater {
      model: root.appStreams;

      VolumeMixerItem {
        required property PwNode modelData;
        node: modelData;
      }
    }
  }
}
