import qs.singletons
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

TextField {
  Layout.fillWidth: true;
  font {
    family: Consts.fontFamMain;
    pixelSize: Consts.fontSizeMain;
  }

  background: Item {}

  color: Colors.c.fg;
  placeholderTextColor: Colors.c.grey;
  selectedTextColor: Colors.c.bg;
  selectionColor: Colors.c.accent;
}
