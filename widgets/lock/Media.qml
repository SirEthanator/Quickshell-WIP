import qs
import qs.components
import qs.utils as Utils
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Widgets;

OutlinedRectangle {
  id: root;

  radius: Globals.vars.br;
  color: Globals.colours.bg;

  anchors.fill: parent;

  ColumnLayout {
    spacing: Globals.vars.paddingCard;

    anchors {
      fill: root.content;
      margins: Globals.vars.paddingCard;
    }

    RowLayout {
      spacing: Globals.vars.paddingCard;

      Layout.fillWidth: true;
      Layout.fillHeight: true;

      ClippingRectangle {
        radius: Globals.vars.br;
        color: "transparent";
        Layout.fillHeight: true;
        Layout.preferredWidth: height;

        Image {
          id: albumCover;
          source: Utils.Mpris.activePlayer.trackArtUrl;
          visible: source.toString() != '';
          anchors.fill: parent;
          asynchronous: true;
        }

        Rectangle {
          color: Globals.colours.bgLight;
          anchors.fill: parent;
          visible: !albumCover.visible;

          Icon {
            icon: "music-note-symbolic";
            size: parent.height - Globals.vars.paddingCard * 2;
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
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.headingFontSize;
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
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.mainFontSize;
          }
          color: Globals.colours.fg;

          Layout.fillWidth: true;
          maximumLineCount: 1;
          elide: Text.ElideRight;
        }
      }
    }

    RowLayout {
      spacing: Globals.vars.paddingCard;
      Layout.fillHeight: true;
      Layout.fillWidth: true;

      RowLayout {
        spacing: Globals.vars.spacingButtonGroup;
        Layout.fillHeight: true;

        Button {
          tlRadius: true; blRadius: true;
          icon: "media-seek-backward-symbolic";
          iconSize: Globals.vars.mainIconSize;
          bg: Globals.colours.bgLight;

          disabled: !Utils.Mpris.activePlayer.canGoPrevious;
          onClicked: {
            if (disabled) return;
            Utils.Mpris.activePlayer.previous();
          }
        }
        Button {
          icon: Utils.Mpris.activePlayer.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
          iconSize: Globals.vars.mainIconSize;
          bg: Globals.colours.bgLight;

          onClicked: Utils.Mpris.activePlayer.togglePlaying();
        }
        Button {
          trRadius: true; brRadius: true;
          icon: "media-seek-forward-symbolic"
          iconSize: Globals.vars.mainIconSize;
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

        ProgressBar {
          Layout.fillWidth: true;
          implicitHeight: 7;
          bg: Globals.colours.bgLight;
          value: Utils.Mpris.posInfo.position / Utils.Mpris.posInfo.length;
        }

        Item {
          Layout.fillWidth: true;
          Text {
            text: Utils.Mpris.posInfo.positionString;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.mainFontSize;
            }
            color: Globals.colours.fg;
            anchors.left: parent.left;
          }
          Text {
            text: Utils.Mpris.posInfo.lengthString;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.mainFontSize;
            }
            color: Globals.colours.fg;
            anchors.right: parent.right;
          }
        }
      }
    }
  }
}

