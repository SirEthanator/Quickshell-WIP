import qs.singletons
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

TextField {
  Layout.fillWidth: true;
  font {
    family: Consts.fontFamily;
    pixelSize: Consts.mainFontSize;
  }

  background: Item {}

  color: Globals.colours.fg;
  placeholderTextColor: Globals.colours.grey;
  selectedTextColor: Globals.colours.bg;
  selectionColor: Globals.colours.accent;
}
