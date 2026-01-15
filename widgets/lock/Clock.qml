import qs.singletons
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  Layout.alignment: Qt.AlignHCenter;

  Text {
    text: Qt.formatDateTime(SysInfo.clock.date, "hh:mm AP");
    Layout.alignment: Qt.AlignHCenter;

    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.largeFontSize;
      variableAxes: {
        "wdth": 200,
        "wght": 1000
      }
    }
  }

  Text {
    text: Qt.formatDateTime(SysInfo.clock.date, "dddd MMM yy");
    Layout.alignment: Qt.AlignHCenter;

    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.headingFontSize;
    }
  }
}

