import qs
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Polkit;

ColumnLayout {
  id: root;
  required property Polkit polkit;
  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Globals.vars.marginCard;

  readonly property AuthFlow flow: polkit.flow;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: root.flow.supplementaryMessage;

    visible: !!text;

    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    color: root.flow.supplementaryIsError ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 3;
    elide: Text.ElideRight;
    wrapMode: Text.Wrap;
  }

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: {
      const flow = root.flow;
      if (root.polkit.isAuthenticating) {
        return "Authenticating..."
      }
      if (flow.failed) {
        return "Authentication Failed."
      }
      return `Authenticating as: ${root.flow.selectedIdentity.displayName}`
    }

    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    color: root.flow.failed ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}

