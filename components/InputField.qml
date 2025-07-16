import qs
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

TextField {
  id: input;
  Layout.fillWidth: true;
  color: Globals.colours.fg;
  font {
    family: Globals.vars.fontFamily;
    pixelSize: Globals.vars.mainFontSize;
  }

  background: Rectangle { color: "transparent" }
  placeholderTextColor: Globals.colours.grey;

  focusPolicy: root.focusPolicy;
}

