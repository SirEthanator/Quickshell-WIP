pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import "root:/components";
import "root:/utils" as Utils;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

LazyLoader {
  id: loader;
  activeAsync: false;
  property bool open: false;

  readonly property int  volume:     Utils.SysInfo.volume;
  readonly property bool mute:       Utils.SysInfo.audioNode.audio.muted;
  readonly property int  brightness: Utils.SysInfo.brightness;

  property var autocloseTimer;
  function show(value, icon) {
    currentValue = value;
    currentIcon = icon;

    if (!unloading) {
      open = true;
      if (!!loader.autocloseTimer) loader.autocloseTimer.destroy();
      loader.autocloseTimer = Utils.Timeout.setTimeout(() => open = false, 3000);
    }
  }

  onVolumeChanged: show(volume, Utils.SysInfo.volumeIcon);
  onMuteChanged: show(volume, Utils.SysInfo.volumeIcon);
  onBrightnessChanged: show(brightness, Utils.SysInfo.brightnessIcon);

  property var unloadTimer;
  readonly property bool unloading: !!unloadTimer;
  onOpenChanged: {
    if (!open) {
      unloadTimer = Utils.Timeout.setTimeout(() => activeAsync = false, Globals.vars.animLen);
    } else {
      loader.activeAsync = true;
    }
  }

  property string currentIcon;
  property string currentValue;

  PanelWindow {
    id: root;
    color: "transparent";
    visible: Globals.configValid === Globals.ConfigState.Valid;

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;

    anchors {
      right: true;
    }

    implicitWidth: content.width + Globals.vars.gapLarge;
    implicitHeight: content.height;

    Anims.SlideFade {
      running: true;
      target: content;
      direction: "left";
      slideOffset: 30;
    }

    Anims.SlideFade {
      running: !open;
      target: content;
      direction: "left";
      reverse: true;
      slideOffset: 30;
    }

    ColumnLayout {
      id: content;
      spacing: Globals.vars.gap;

      ProgressBar {
        id: progress;

        vertical: true;
        implicitHeight: 350;
        implicitWidth: 50;
        radius: Globals.vars.br;
        value: loader.currentValue / 100;
        bg: Globals.colours.bg;
        fg: loader.currentValue >= 90 ? Globals.colours.red : Globals.colours.accent;
        icon: loader.currentIcon;

        border {
          color: Globals.colours.outline;
          width: Globals.vars.outlineSize;
          pixelAligned: false;
        }
      }

      Rectangle {
        color: Globals.colours.bg;
        Layout.fillWidth: true;
        implicitHeight: percentageText.height + Globals.vars.paddingButton * 2;
        radius: Globals.vars.br;

        border {
          color: Globals.colours.outline;
          width: Globals.vars.outlineSize;
          pixelAligned: false;
        }

        Text {
          id: percentageText;
          anchors.centerIn: parent;
          text: `${loader.currentValue}%`;
          color: Globals.colours.fg;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.mainFontSize
          }
        }
      }
    }
  }
}

