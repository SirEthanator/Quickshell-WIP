import "root:/";
import "root:/utils" as Utils;
import Quickshell;
import QtQuick;

BarModule {
  icon: "calendar-symbolic";
  iconbgColour: Globals.colours.dateAndTime;

  Text {
    id: clockText
    color: Globals.colours.fg;
    font: Globals.vars.mainFont

    text: Utils.SysInfo.dateAndTime;
  }
}
