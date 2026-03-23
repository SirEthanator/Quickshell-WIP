import qs.singletons
import qs.components
import Quickshell.Services.Pipewire;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property PwNode node;

  property string iconOverride;
  property bool colorizeIcon: false;
  property color iconColor: Colors.c.fg;
  property bool useNickname: false;

  spacing: Consts.paddingSmall;

  visible: node.ready;

  Icon {
    icon: root.iconOverride || root.node.properties["application.icon-name"] || fallback;
    isMask: root.colorizeIcon;
    color: root.iconColor;
    visible: !!icon;

    fallback: "multimedia-audio-player";

    Layout.fillHeight: true;
    size: height;
  }

  ColumnLayout {
    Layout.minimumWidth: 280;
    spacing: 4;

    RowLayout {
      spacing: Consts.paddingSmall;
      Layout.fillWidth: true;

      Text {
        id: title;
        text: root.useNickname ? root.node.nickname : root.node.name;
        color: Colors.c.fg;
        font {
          family: Consts.fontFamMain;
          pixelSize: Consts.fontSizeMedium;
        }

        Layout.fillWidth: true;
        Layout.fillHeight: true;
        horizontalAlignment: Qt.AlignLeft;
        verticalAlignment: Qt.AlignVCenter;
      }

      Button {
        icon: "audio-volume-muted";
        active: root.node.audio.muted;
        iconSize: Consts.iconSizeSmall;
        padding: 6;
        bg: Colors.c.bgLight;
        allRadius: true;
        onClicked: root.node.audio.muted = !root.node.audio.muted;
      }
    }

    RowLayout {
      // The scrubber overflows, so it is not part of slider's width.
      // To get the correct spacing when volume is full, we add the max
      // amount of overflow of the scrubber.
      spacing: slider.scrubberSize / 2 + 6;

      InteractiveProgressBar {
        id: slider;

        Layout.fillWidth: true;

        bg: Colors.c.bgLight;
        value: root.node.audio.volume;

        enableScrolling: true;

        maxValue: 1.5;
        warningThreshold: 1.0;
        dangerThreshold: 1.2;

        onUserChange: {
          root.node.audio.volume = Math.round(value * 100) / 100;
          value = Qt.binding(() => root.node.audio.volume);
        }
      }

      Text {
        id: valueText;
        text: `${Math.round(slider.clampedValue * 100)}%`;
        color: Colors.c.fg;

        TextMetrics {
          id: valueTextMetrics;
          font: valueText.font;
          text: `${slider.maxValue * 100}%`; // Longest possible value
        }

        // Ensures no layout shifts happen when value changes
        Layout.preferredWidth: valueTextMetrics.width;
        horizontalAlignment: Qt.AlignLeft;

        font {
          family: Consts.fontFamMono;
          pixelSize: Consts.fontSizeMain;
        }
      }
    }
  }
}
