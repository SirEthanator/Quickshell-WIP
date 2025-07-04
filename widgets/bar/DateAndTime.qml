import "root:/";
import "root:/utils" as Utils;
import QtQuick;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColour: Globals.colours.dateAndTime;
  tooltip: TooltipItem {
    // Placeholder - Replace with calendar
    Text {
      text: Utils.SysInfo.dateAndTime;
      color: Globals.colours.fg;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }
  }

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
