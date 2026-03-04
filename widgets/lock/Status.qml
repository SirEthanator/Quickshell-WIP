import qs.singletons
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  required property Pam pam;
  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Consts.marginCard;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: root.pam.message;
    visible: !!text && text !== "Password: ";
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
    color: Globals.colors.grey;
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
        default: return `Logged in as: ${SysInfo.username}`
      }
    }
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
    color: root.pam.state === "failed" || root.pam.state === "error"
      ? Globals.colors.warning
      : root.pam.state === "maxTries"
        ? Globals.colors.red
        : Globals.colors.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}
