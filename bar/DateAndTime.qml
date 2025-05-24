import "root:/";
import "root:/utils" as Utils;
import Quickshell;
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
