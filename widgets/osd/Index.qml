pragma ComponentBehavior: Bound

import qs.singletons
import qs.animations as Anims;
import qs.components
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

LazyLoader {
  id: root;
  activeAsync: false;
  property bool open: false;

  onOpenChanged: {
    if (open) {
      activeAsync = true;
    }
  }

  readonly property int  volume: SysInfo.volume;
  readonly property bool mute: SysInfo.audioNode.audio.muted;
  readonly property int  brightness: SysInfo.brightness;

  onVolumeChanged: show("volume");
  onMuteChanged: show("volume");
  onBrightnessChanged: show("brightness");

  property bool inhibitHide: false;

  onInhibitHideChanged: {
    if (inhibitHide) {
      hideTimer.stop();
    } else {
      hideTimer.restart();
    }
  }

  function show(mode) {
    if (!inhibitHide) hideTimer.restart();
    currentMode = mode;
    root.open = true;
  }

  function getIcon(mode: string): string {
    switch (mode) {
      case "volume": return SysInfo.volumeIcon;
      case "brightness": return SysInfo.brightnessIcon;
      default: return "";
    }
  }

  function getValue(mode: string): real {
    switch (mode) {
      case "volume": return root.volume / 100;
      case "brightness": return root.brightness / 100;
      default: return 0.0;
    }
  }

  property string currentMode;
  property real currentValue: getValue(currentMode);
  property string currentIcon: getIcon(currentMode);

  readonly property Timer hideTimer: Timer {
    interval: Conf.osd.hideTimeout;

    onTriggered: {
      root.open = false;
    }
  }

  PanelWindow {
    color: "transparent";

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;

    anchors {
      right: true;
    }

    implicitWidth: content.width + Consts.gapLarge;
    implicitHeight: content.height;

    Anims.Slide {
      running: root.open;
      target: content;
      direction: Anims.Slide.Left;
      slideOffset: 60;
      scaleOffset: 0.85;
      grow: true;
    }

    SequentialAnimation {
      running: !root.open;

      Anims.Slide {
        target: content;
        direction: Anims.Slide.Left;
        reverse: true;
        slideOffset: 30;
      }
      PropertyAction { target: root; property: "activeAsync"; value: false }
    }

    ColumnLayout {
      id: content;
      spacing: Consts.gap;

      OutlinedRectangle {
        id: progressWrapper;
        color: Globals.colours.bg;
        implicitHeight: 350 + outlineSize * 2;
        implicitWidth: 50 + outlineSize * 2;

        InteractiveProgressBar {
          id: progress;

          radius: 0;
          topLeftRadius: progressWrapper.content.topLeftRadius;
          topRightRadius: progressWrapper.content.topRightRadius;

          anchors {
            left: parent.content.left;
            right: parent.content.right;
            top: parent.content.top;
            bottom: iconWrapper.top;
            bottomMargin: -1; // Prevents tiny gap
          }

          vertical: true;
          value: root.currentValue;

          bg: Globals.colours.bg;
          fg: value >= 0.9 ? Globals.colours.red : value >= 0.75 ? Globals.colours.warning : Globals.colours.accent;

          enableInteractivity: root.currentMode === "volume";
          enableScrolling: true;

          showScrubber: false;

          onUserChange: {
            if (root.currentMode === "volume") {
              SysInfo.audioNode.audio.volume = Math.round(value * 100) / 100;
            }
            value = Qt.binding(() => root.currentValue);
          }

          onDraggingChanged: {
            if (dragging) {
              root.inhibitHide = true;
            } else {
              root.inhibitHide = false;
            }
          }
        }

        Rectangle {
          id: iconWrapper;

          anchors {
            left: parent.content.left;
            right: parent.content.right;
            bottom: parent.content.bottom;
          }

          height: width;
          color: progress.fg;
          bottomLeftRadius: progressWrapper.content.bottomLeftRadius;
          bottomRightRadius: progressWrapper.content.bottomRightRadius;

          Anims.ColourTransition on color {}

          Icon {
            anchors.fill: parent;
            color: progress.bg;
            icon: root.currentIcon;
          }
        }
      }

      OutlinedRectangle {
        color: Globals.colours.bg;
        Layout.fillWidth: true;
        implicitHeight: percentageText.height + Consts.paddingButton * 2 + outlineSize * 2;
        radius: Consts.br;

        Text {
          id: percentageText;
          text: `${Math.round(progress.clampedValue * 100)}%`;
          color: Globals.colours.fg;
          anchors.centerIn: parent.content;

          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize
          }
        }
      }
    }
  }
}

