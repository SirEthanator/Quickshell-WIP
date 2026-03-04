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

  color: Globals.colors.fg;
  placeholderTextColor: Globals.colors.grey;
  selectedTextColor: Globals.colors.bg;
  selectionColor: Globals.colors.accent;
}
