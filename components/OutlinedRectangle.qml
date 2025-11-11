import qs
import QtQuick;

Item {
  id: root;

  property alias radius: outline.radius;
  property alias topRightRadius: outline.topRightRadius;
  property alias topLeftRadius: outline.topLeftRadius;
  property alias bottomRightRadius: outline.bottomRightRadius;
  property alias bottomLeftRadius: outline.bottomLeftRadius;
  property alias color: content.color;
  property alias outlineColor: outline.color;

  property bool disableAllOutlines: false;
  property bool leftOutline: true;
  property bool rightOutline: true;
  property bool topOutline: true;
  property bool bottomOutline: true;

  property real outlineSize: Globals.vars.outlineSize;

  readonly property alias content: content;

  layer.enabled: true;

  Rectangle {
    id: outline;
    anchors.fill: parent;

    color: Globals.colours.outline;
    radius: Globals.vars.br;

    visible: !root.disableAllOutlines && (root.leftOutline || root.rightOutline || root.topOutline || root.bottomOutline);
  }

  Rectangle {
    id: content;
    anchors {
      fill: outline;
      leftMargin: root.leftOutline && !root.disableAllOutlines ? root.outlineSize : 0;
      rightMargin: root.rightOutline && !root.disableAllOutlines ? root.outlineSize : 0;
      topMargin: root.topOutline && !root.disableAllOutlines ? root.outlineSize : 0;
      bottomMargin: root.bottomOutline && !root.disableAllOutlines ? root.outlineSize : 0;
    }

    function getRadius(radius: real): real {
      return Math.max(0, radius - root.outlineSize);
    }

    topLeftRadius: (root.leftOutline && root.topOutline) ? getRadius(root.topLeftRadius) :
                   (!root.leftOutline && !root.topOutline) ? outline.radius : 0;
    topRightRadius: (root.rightOutline && root.topOutline) ? getRadius(root.topRightRadius) :
                    (!root.rightOutline && !root.topOutline) ? outline.radius : 0;
    bottomLeftRadius: (root.leftOutline && root.bottomOutline) ? getRadius(root.bottomLeftRadius) :
                      (!root.leftOutline && !root.bottomOutline) ? outline.radius : 0;
    bottomRightRadius: (root.rightOutline && root.bottomOutline) ? getRadius(root.bottomRightRadius) :
                       (!root.rightOutline && !root.bottomOutline) ? outline.radius : 0;
  }
}

