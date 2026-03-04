import qs.singletons
import qs.components
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property real percentage;
  required property string title;
  property string extraInfo;
  spacing: Consts.paddingCard;

  CircularProgress {
    implicitHeight: 80;
    implicitWidth: 80;
    value: root.percentage / 100;
    fg: value >= 0.9 ? Globals.colors.red : value >= 0.75 ? Globals.colors.warning : Globals.colors.accent;
  }

  ColumnLayout {
    spacing: Consts.marginCardSmall;

    Text {
      text: root.title;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mediumHeadingFontSize;
        variableAxes: {
          "wght": 600
        }
      }
      color: Globals.colors.fg;
    }

    Text {
      text: root.extraInfo;
      visible: !!root.extraInfo;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
      color: Globals.colors.grey;
    }
  }
}

