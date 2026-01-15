import qs.singletons
import QtQuick;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  Text {
    id: clockText
    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    text: SysInfo.dateAndTime;
  }
}
