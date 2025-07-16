import qs
import qs.utils as Utils;
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  required property Pam pam;
  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Globals.vars.marginCard;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: root.pam.message;
    visible: !!text && text !== "Password: ";
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    color: Globals.colours.grey;
    maximumLineCount: 1;
    elide: Text.ElideRight;
  }

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: {
      switch (root.pam.state) {
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
    color: root.pam.state === "failed" || root.pam.state === "error"
        ? Globals.colours.warning
        : root.pam.state === "maxTries"
          ? Globals.colours.red
          : Globals.colours.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}
