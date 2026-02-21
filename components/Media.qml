import qs.singletons
import qs.components
import qs.utils as Utils;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Effects;
import Quickshell.Widgets;

OutlinedRectangle {
  id: root;

  radius: Consts.br;
  color: Globals.colours.bg;

  Image {
    id: backgroundArt;
    source: Utils.Mpris.activePlayer.trackArtUrl;
    asynchronous: true;

    // Find diagonal distance between corners and double it to ensure
    // full coverage at all times with minimal overflow.
    readonly property int imgSize: Math.ceil(
      Math.hypot(
        root.content.width,
        root.content.height
      ) * 2
    )

    width: imgSize;
    height: imgSize;

    visible: false;
  }

  ClippingRectangle {
    anchors.fill: root.content;
    // Could be any corner's radius, they are all the same
    radius: root.content.topLeftRadius;
    visible: backgroundArt.source.toString() !== "";

    color: "transparent";

    Item {
      id: blurredBackgroundWrapper;
      width: backgroundArt.width;
      height: backgroundArt.height;

      anchors {
        verticalCenter: parent.top;
        horizontalCenter: parent.left;
      }

      MultiEffect {
        source: backgroundArt;
        anchors.fill: parent;

        blurEnabled: true;
        blur: 1;
        blurMax: 128;
        blurMultiplier: 1;
      }

      NumberAnimation on rotation {
        running: true;
        paused: !Utils.Mpris.activePlayer.isPlaying;
        loops: NumberAnimation.Infinite;
        from: 0;
        to: 360;
        duration: 60_000;
      }
    }

    Rectangle {
      anchors.fill: parent;
      color: Qt.rgba(0, 0, 0, 0.3);
    }
  }

  ColumnLayout {
    spacing: Consts.paddingCard;

    anchors {
      fill: root.content;
      margins: Consts.paddingCard;
    }

    RowLayout {
      spacing: Consts.paddingCard;

      Layout.fillWidth: true;
      Layout.fillHeight: true;

      ClippingRectangle {
        radius: Consts.br;
        color: "transparent";
        Layout.fillHeight: true;
        Layout.preferredWidth: height;

        Image {
          id: albumCover;
          source: Utils.Mpris.activePlayer.trackArtUrl;
          visible: source.toString() !== "";
          anchors.fill: parent;
          asynchronous: true;
        }

        Rectangle {
          color: Globals.colours.bgLight;
          anchors.fill: parent;
          visible: !albumCover.visible;

          Icon {
            icon: "music-note-symbolic";
            size: parent.height - Consts.paddingCard * 2;
            anchors.centerIn: parent;
          }
        }
      }

      ColumnLayout {
        spacing: 3;
        Layout.fillWidth: true;
        Layout.alignment: Qt.AlignVCenter;

        Text {
          text: Utils.Mpris.activePlayer.trackTitle || "Unknown Track";
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.headingFontSize;
            bold: true;
          }
          color: Globals.colours.fg;

          Layout.fillWidth: true;
          maximumLineCount: 1;
          elide: Text.ElideRight;
        }

        Text {
          text: Utils.Mpris.activePlayer.trackArtist || "Unknown Artist";
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }
          color: Globals.colours.fg;

          Layout.fillWidth: true;
          maximumLineCount: 1;
          elide: Text.ElideRight;
        }
      }
    }

    RowLayout {
      spacing: Consts.paddingCard;
      Layout.fillHeight: true;
      Layout.fillWidth: true;

      RowLayout {
        spacing: Consts.spacingButtonGroup;
        Layout.fillHeight: true;

        Button {
          tlRadius: true; blRadius: true;
          icon: "media-seek-backward-symbolic";
          iconSize: Consts.mainIconSize;
          bg: Globals.colours.bgLight;

          disabled: !Utils.Mpris.activePlayer.canGoPrevious;
          onClicked: {
            if (disabled) return;
            Utils.Mpris.activePlayer.previous();
          }
        }
        Button {
          icon: Utils.Mpris.activePlayer.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
          iconSize: Consts.mainIconSize;
          bg: Globals.colours.bgLight;

          onClicked: Utils.Mpris.activePlayer.togglePlaying();
        }
        Button {
          trRadius: true; brRadius: true;
          icon: "media-seek-forward-symbolic"
          iconSize: Consts.mainIconSize;
          bg: Globals.colours.bgLight;

          disabled: !Utils.Mpris.activePlayer.canGoNext;
          onClicked: {
            if (disabled) return;
            Utils.Mpris.activePlayer.next();
          }
        }
      }

      ColumnLayout {
        spacing: 3;
        Layout.alignment: Qt.AlignVCenter;

        InteractiveProgressBar {
          Layout.fillWidth: true;
          implicitHeight: 7;
          bg: Globals.colours.bgLight;
          value: Utils.Mpris.posInfo.positionPercent;

          enableInteractivity: Utils.Mpris.activePlayer.canSeek && Utils.Mpris.activePlayer.positionSupported;

          onUserChange: {
            Utils.Mpris.activePlayer.position = Utils.Mpris.posInfo.length * value;
            value = Qt.binding(() => Utils.Mpris.posInfo.positionPercent);
          }
        }

        Item {
          Layout.fillWidth: true;
          Text {
            text: Utils.Mpris.posInfo.positionString;
            font {
              family: Consts.fontFamily;
              pixelSize: Consts.mainFontSize;
            }
            color: Globals.colours.fg;
            anchors.left: parent.left;
          }
          Text {
            text: Utils.Mpris.posInfo.lengthString;
            font {
              family: Consts.fontFamily;
              pixelSize: Consts.mainFontSize;
            }
            color: Globals.colours.fg;
            anchors.right: parent.right;
          }
        }
      }
    }
  }
}

