import qs.singletons
import qs.components
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  required property real percentage;
  required property string title;
  property string extraInfo;
  spacing: Consts.paddingLarge;

  CircularProgress {
    implicitHeight: 80;
    implicitWidth: 80;
    value: root.percentage / 100;
    fg: value >= 0.9 ? Colors.c.red : value >= 0.75 ? Colors.c.warning : Colors.c.accent;
  }

  ColumnLayout {
    spacing: Consts.paddingXSmall;

    Text {
      text: root.title;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMedLarge;
        variableAxes: {
          "wght": 600
        }
      }
      color: Colors.c.fg;
    }

    Text {
      text: root.extraInfo;
      visible: !!root.extraInfo;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
      }
      color: Colors.c.grey;
    }
  }
}

