import qs
import qs.utils as Utils;
import QtQuick;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  Text {
    id: clockText
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    text: Utils.SysInfo.dateAndTime;
  }
}
