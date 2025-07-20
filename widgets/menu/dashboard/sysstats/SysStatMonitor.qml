import qs
import qs.components
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property real percentage;
  required property string title;
  property string extraInfo;
  spacing: Globals.vars.paddingCard;

  CircularProgress {
    implicitHeight: 80;
    implicitWidth: 80;
    value: root.percentage / 100;
    fg: value >= 0.9 ? Globals.colours.red : value >= 0.75 ? Globals.colours.warning : Globals.colours.accent;
  }

  ColumnLayout {
    spacing: Globals.vars.marginCardSmall;

    Text {
      text: root.title;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mediumHeadingFontSize;
      }
      color: Globals.colours.fg;
    }

    Text {
      text: root.extraInfo;
      visible: !!root.extraInfo;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
      color: Globals.colours.grey;
    }
  }
}

