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
  required property var screen;
  activeAsync: false;
  property bool open: false;

  readonly property int  volume: Utils.SysInfo.volume;
  readonly property bool mute:   Utils.SysInfo.audioNode.audio.muted;

  property var autocloseTimer;
  function show() {
    if (unloading) return
    open = true;
    if (!!loader.autocloseTimer) {loader.autocloseTimer.destroy()}
    loader.autocloseTimer = Utils.Timeout.setTimeout(() => open = false, 3000);
  }
  onVolumeChanged: show();
  onMuteChanged: show();

  property var unloadTimer;
  readonly property bool unloading: !!unloadTimer;
  onOpenChanged: {
    if (!open) {
      unloadTimer = Utils.Timeout.setTimeout(() => activeAsync = false, Globals.vars.animLen);
    } else {
      loader.activeAsync = true;
    }
  }

  PanelWindow {
    id: root;
    color: "transparent";
    screen: loader.screen;

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;

    anchors {
      top: true;
      bottom: true;
      right: true;
    }

    implicitWidth: progress.width + Globals.vars.gapLarge * 2;

    Anims.SlideFade {
      running: true;
      slideTarget: root;
      fadeTarget: content;
      direction: "left";
    }

    Anims.SlideFade {
      running: !open;
      slideTarget: root;
      fadeTarget: content;
      direction: "left";
      reverse: true;
    }

    ColumnLayout {
      id: content;
      anchors.centerIn: parent;
      spacing: Globals.vars.gap;

      ProgressBar {
        id: progress;

        vertical: true;
        height: 350;
        width: 50;
        radius: Globals.vars.br;
        value: loader.volume / 100;
        bg: Globals.colours.bg;
        fg: Globals.colours.accent;
        icon: Utils.SysInfo.volumeIcon;

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
          text: `${loader.volume}%`;
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

