import "root:/";
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

Rectangle {
  id: root;
  color: borderColor;
  radius: Globals.vars.br;

  default property alias data: row.data;

  property color bg: Globals.colours.bgLight;
  property bool leftPadding: true;
  property bool rightPadding: true;
  property bool showBorder: true;
  property color borderColor: Globals.colours.outline;
  property string icon: "";

  property alias textColor: input.color;
  property alias font: input.font;
  property alias placeholderText: input.placeholderText;
  property alias placeholderTextColor: input.placeholderTextColor;
  property alias echoMode: input.echoMode;
  property alias inputMethodHints: input.inputMethodHints;
  property alias text: input.text;
  property alias inputFocus: input.focus;

  signal accepted;

  function clear() { input.clear() }
  function insert(pos: int, text: string) { input.insert(pos, text) }

  implicitHeight: input.height + Globals.vars.paddingButton * 2 + Globals.vars.outlineSize * 2;

  onFocusChanged: {
    if (focus) {
      focus = false;
      input.focus = true;
    }
  }

  Rectangle {
    anchors {
      fill: parent;
      margins: root.showBorder ? Globals.vars.outlineSize : 0;
    }
    color: root.bg;
    radius: parent.radius - Globals.vars.outlineSize;  // inner = outer - padding

    RowLayout {
      id: row;
      spacing: Globals.vars.paddingButton;
      anchors.fill: parent;
      anchors.leftMargin: root.leftPadding ? spacing : 0;
      anchors.rightMargin: root.rightPadding ? spacing : 0;

      Icon {
        visible: !!root.icon;
        icon: root.icon;
        color: Globals.colours.fg;
        Layout.alignment: Qt.AlignVCenter;
      }

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

        onAccepted: root.accepted();

        focusPolicy: root.focusPolicy;
      }
    }
  }
}
