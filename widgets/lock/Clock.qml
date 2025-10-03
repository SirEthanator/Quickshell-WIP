import qs
import qs.utils as Utils;
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  Layout.alignment: Qt.AlignHCenter;

  Text {
    text: Qt.formatDateTime(Utils.SysInfo.clock.date, "hh:mm AP");
    Layout.alignment: Qt.AlignHCenter;

    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.largeFontSize;
      variableAxes: {
        "wdth": 200,
        "wght": 1000
      }
    }
  }

  Text {
    text: Qt.formatDateTime(Utils.SysInfo.clock.date, "dddd MMM yy");
    Layout.alignment: Qt.AlignHCenter;

    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.headingFontSize;
    }
  }
}

