import qs.singletons
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  required property Pam pam;
  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Consts.paddingMedium;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: root.pam.message;
    visible: !!text && text !== "Password: ";
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeMain;
    }
    color: Colors.c.grey;
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
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeMain;
    }
    color: root.pam.state === "failed" || root.pam.state === "error"
      ? Colors.c.warning
      : root.pam.state === "maxTries"
        ? Colors.c.red
        : Colors.c.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}
