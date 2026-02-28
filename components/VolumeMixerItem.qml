import qs.singletons
import qs.components
import Quickshell.Services.Pipewire;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property PwNode node;

  property string iconOverride;
  property bool useNickname: false;

  spacing: Consts.paddingModule;

  visible: node.ready;

  Icon {
    id: icon;
    icon: root.iconOverride || root.node.properties["application.icon-name"];
    isMask: false;
    visible: !!icon;

    fallback: "multimedia-audio-player";

    Layout.fillHeight: true;
    size: height;
  }

  ColumnLayout {
    Layout.minimumWidth: 280;
    spacing: 4;

    RowLayout {
      spacing: Consts.paddingModule;
      Layout.fillWidth: true;

      Text {
        id: title;
        text: root.useNickname ? root.node.nickname : root.node.name;
        color: Globals.colours.fg;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mediumFontSize;
        }

        Layout.fillWidth: true;
        Layout.fillHeight: true;
        horizontalAlignment: Qt.AlignLeft;
        verticalAlignment: Qt.AlignVCenter;
      }

      Button {
        icon: "audio-volume-muted";
        active: root.node.audio.muted;
        iconSize: Consts.smallIconSize;
        padding: 6;
        bg: Globals.colours.bgLight;
        allRadius: true;
        onClicked: root.node.audio.muted = !root.node.audio.muted;
      }
    }

    RowLayout {
      // The scrubber overflows, so it is not part of slider's width.
      // To get the correct spacing when volume is at 100%, we add the max
      // amount of overflow of the scrubber.
      spacing: slider.scrubberSize / 2 + 6;

      InteractiveProgressBar {
        id: slider;

        Layout.fillWidth: true;
        implicitHeight: Consts.progressBarHeight;

        bg: Globals.colours.bgLight;
        value: root.node.audio.volume;

        onUserChange: {
          root.node.audio.volume = Math.round(value * 100) / 100;
          value = Qt.binding(() => root.node.audio.volume);
        }
      }

      Text {
        id: valueText;
        text: `${Math.round(slider.clampedValue * 100)}%`;
        color: Globals.colours.fg;

        TextMetrics {
          id: valueTextMetrics;
          font: valueText.font;
          text: "100%"; // Longest possible value
        }

        // Ensures no layout shifts happen when value changes
        Layout.preferredWidth: valueTextMetrics.width;
        horizontalAlignment: Qt.AlignLeft;

        font {
          family: Consts.fontMono;
          pixelSize: Consts.mainFontSize;
        }
      }
    }
  }
}
