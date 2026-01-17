import qs.singletons
import qs.widgets.polkit  // For LSP
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;

  required property Polkit polkit;

  anchors.bottom: parent.bottom;
  anchors.horizontalCenter: parent.horizontalCenter;

  spacing: Consts.marginCard;

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: root.polkit.flow.supplementaryMessage;

    visible: !!text;

    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    color: root.polkit.flow.supplementaryIsError ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 3;
    elide: Text.ElideRight;
    wrapMode: Text.Wrap;
  }

  Text {
    Layout.alignment: Qt.AlignHCenter;

    text: {
      const flow = root.polkit.flow;
      if (root.polkit.isAuthenticating) {
        return "Authenticating..."
      }
      if (flow.failed) {
        return "Authentication Failed."
      }
      return `Authenticating as: ${root.polkit.flow.selectedIdentity.displayName}`
    }

    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    color: root.polkit.flow.failed ? Globals.colours.red : Globals.colours.grey;

    maximumLineCount: 1;
    elide: Text.ElideRight;
  }
}

