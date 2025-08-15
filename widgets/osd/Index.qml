pragma ComponentBehavior: Bound

import qs
import qs.animations as Anims;
import qs.components
import qs.utils as Utils;
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

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;

    anchors {
      right: true;
    }

    implicitWidth: content.width + Globals.vars.gapLarge;
    implicitHeight: content.height;

    Anims.Slide {
      running: true;
      target: content;
      direction: Anims.Slide.Left;
      slideOffset: 60;
      scaleOffset: 0.85;
      grow: true;
    }

    Anims.Slide {
      running: !loader.open;
      target: content;
      direction: Anims.Slide.Left;
      reverse: true;
      slideOffset: 30;
    }

    ColumnLayout {
      id: content;
      spacing: Globals.vars.gap;

      OutlinedRectangle {
        id: progressWrapper;
        color: Globals.colours.bg;
        implicitHeight: 350 + outlineSize * 2;
        implicitWidth: 50 + outlineSize * 2;

        ProgressBar {
          id: progress;
          anchors.fill: progressWrapper.content;
          radius: progressWrapper.content.topLeftRadius;  // All radii are the same

          vertical: true;
          value: loader.currentValue / 100;
          bg: Globals.colours.bg;
          fg: loader.currentValue >= 90 ? Globals.colours.red : loader.currentValue >= 75 ? Globals.colours.warning : Globals.colours.accent;
          icon: loader.currentIcon;
        }
      }

      OutlinedRectangle {
        color: Globals.colours.bg;
        Layout.fillWidth: true;
        implicitHeight: percentageText.height + Globals.vars.paddingButton * 2 + outlineSize * 2;
        radius: Globals.vars.br;

        Text {
          id: percentageText;
          anchors.centerIn: parent.content;
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

