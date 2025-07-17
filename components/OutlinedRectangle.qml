import qs
import QtQuick;

Item {
  id: root;

  property alias radius: outline.radius;
  property alias color: content.color;
  property alias outlineColor: outline.color;

  property bool leftOutline: true;
  property bool rightOutline: true;
  property bool topOutline: true;
  property bool bottomOutline: true;

  property real outlineSize: Globals.vars.outlineSize;

  readonly property alias content: content;

  Rectangle {
    id: outline;
    anchors.fill: parent;

    color: Globals.colours.outline;
    radius: Globals.vars.br;

    visible: root.leftOutline || root.rightOutline || root.topOutline || root.bottomOutline;
  }

  Rectangle {
    id: content;
    anchors {
      fill: outline;
      leftMargin: root.leftOutline ? root.outlineSize : 0;
      rightMargin: root.rightOutline ? root.outlineSize : 0;
      topMargin: root.topOutline ? root.outlineSize : 0;
      bottomMargin: root.bottomOutline ? root.outlineSize : 0;
    }

    readonly property real adjustedRadius: Math.max(0, outline.radius - root.outlineSize);
    topLeftRadius: (root.leftOutline && root.topOutline) ? adjustedRadius :
                   (!root.leftOutline && !root.topOutline) ? outline.radius : 0;
    topRightRadius: (root.rightOutline && root.topOutline) ? adjustedRadius :
                    (!root.rightOutline && !root.topOutline) ? outline.radius : 0;
    bottomLeftRadius: (root.leftOutline && root.bottomOutline) ? adjustedRadius :
                      (!root.leftOutline && !root.bottomOutline) ? outline.radius : 0;
    bottomRightRadius: (root.rightOutline && root.bottomOutline) ? adjustedRadius :
                       (!root.rightOutline && !root.bottomOutline) ? outline.radius : 0;
  }
}

