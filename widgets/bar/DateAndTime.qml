import qs.singletons
import QtQuick;

BarModule {
  icon: "calendar-month-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  tooltip: Tooltip {
    Text {
      text: `Date & Time - ${SysInfo.dateTime("ddd dd/MM/yy | hh:mm:ss ap")}`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  menu: Tooltip {
    Text {
      text: "Placeholder - Show calendar";
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  Text {
    id: clockText
    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    text: SysInfo.dateTime("ddd dd/MM | hh:mm ap");
  }
}
