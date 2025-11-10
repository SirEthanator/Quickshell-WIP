import qs
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Globals.vars.marginCard;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: Polkit.flow.supplementaryMessage;

    visible: !!text;

    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    color: Polkit.flow.supplementaryIsError ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 3;
    elide: Text.ElideRight;
    wrapMode: Text.Wrap;
  }

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: {
      const flow = Polkit.flow;
      if (Polkit.isAuthenticating) {
        return "Authenticating..."
      }
      if (flow.failed) {
        return "Authentication Failed."
      }
      return `Authenticating as: ${Polkit.flow.selectedIdentity.displayName}`
    }

    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    color: Polkit.flow.failed ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}

