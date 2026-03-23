import qs.singletons
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  Layout.alignment: Qt.AlignHCenter;

  Text {
    text: SysInfo.dateTime("hh:mm AP");
    Layout.alignment: Qt.AlignHCenter;

    color: Colors.c.fg;
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeXLarge;
      variableAxes: {
        "wdth": 200,
        "wght": 1000
      }
    }
  }

  Text {
    text: SysInfo.dateTime("dddd MMM dd");
    Layout.alignment: Qt.AlignHCenter;

    color: Colors.c.fg;
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeLarge;
    }
  }
}

