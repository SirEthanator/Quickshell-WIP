import "root:/";
import "root:/utils" as Utils;
import QtQuick;
import QtQuick.Layouts;

Text {
  required property Pam pam;
  Layout.alignment: Qt.AlignHCenter;

  text: pam.state === "authenticating"
    ? "Authenticating..."
    : pam.state === "failed"
      ? "Incorrect password."
      : pam.state === "error"
        ? "Error authenticating."
        : pam.state === "maxTries"
          ? "Maximum attempts reached."
          : `Logged in as: ${Utils.SysInfo.username}`
  font {
    family: Globals.vars.fontFamily;
    pixelSize: Globals.vars.mainFontSize;
  }
  color: pam.state === "failed" || pam.state === "error"
      ? Globals.colours.warning
      : pam.state === "maxTries"
        ? Globals.colours.red
        : Globals.colours.grey;
}
