import "root:/";
import "root:/utils" as Utils;
import QtQuick;
import QtQuick.Layouts;

Text {
  required property Pam pam;
  Layout.alignment: Qt.AlignHCenter;

  text: {
    if (pam.stateIsMessage) {
      return pam.state;
    }
    switch (pam.state) {
      case "authenticating": return "Authenticating...";
      case "failed": return "Incorrect password.";
      case "error": return "Error authenticating.";
      case "maxTries": return "Maximum attempts reached."
      default: return `Logged in as: ${Utils.SysInfo.username}`
    }
  }
  font {
    family: Globals.vars.fontFamily;
    pixelSize: Globals.vars.mainFontSize;
  }
  color: pam.state === "failed" || pam.state === "error"
      ? Globals.colours.warning
      : pam.state === "maxTries"
        ? Globals.colours.red
        : Globals.colours.grey;

  maximumLineCount: 1;
  elide: Text.ElideRight;
}
