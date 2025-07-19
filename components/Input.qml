import qs
import QtQuick;
import QtQuick.Layouts;

OutlinedRectangle {
  id: root;

  outlineColor: borderColor;
  color: bg;
  radius: Globals.vars.br;

  default property list<QtObject> data;

  required property InputField field;

  property color bg: Globals.colours.bgLight;
  property bool leftPadding: true;
  property bool rightPadding: true;
  property bool topPadding: true;
  property bool bottomPadding: true;
  property bool showBorder: true;
  property color borderColor: Globals.colours.outline;
  property string icon: "";

  disableAllOutlines: !showBorder;

  implicitHeight: row.implicitHeight + Globals.vars.paddingButton * (topPadding && bottomPadding ? 2 : topPadding || bottomPadding ? 1 : 0) + Globals.vars.outlineSize * 2;

  onFocusChanged: {
    if (focus) {
      focus = false;
      field.focus = true;
    }
  }

    RowLayout {
      id: row;
      spacing: Globals.vars.paddingButton;

      anchors {
        fill: parent.content;
        leftMargin: root.leftPadding ? spacing : 0;
        rightMargin: root.rightPadding ? spacing : 0;
        topMargin: root.topPadding ? spacing : 0;
        bottomMargin: root.bottomPadding ? spacing : 0;
      }

      Icon {
        visible: !!root.icon;
        icon: root.icon;
        color: Globals.colours.fg;
        Layout.alignment: Qt.AlignVCenter;
      }

      Component.onCompleted: {
        root.field.parent = this;
        // Place children after the field
        for (let i=0; i < root.data.length; i++) {
          const item = root.data[i];
          if (typeof item !== "undefined" && typeof item.parent !== "undefined") {
            item.parent = this;
          }
        }
      }
    }
}
